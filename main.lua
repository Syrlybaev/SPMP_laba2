-- ==============================
-- Игра "Жизнь" Конвея на Lua
-- ==============================

-- Если клетка живая:
-- меньше 2 соседей → умирает
-- 2 или 3 соседа → живет
-- больше 3 соседей → умирает

-- Если клетка мертвая:
-- ровно 3 соседа → оживает
-- иначе остается мертвой


local ROWS = 20
local COLS = 40
local STEPS = 100
local DELAY = 0.2

-- Создание двумерного массива, заполненного нулями
local function createField(rows, cols)
    local field = {}
    for i = 1, rows do
        field[i] = {}
        for j = 1, cols do
            field[i][j] = 0
        end
    end
    return field
end

-- Копирование начального состояния в поле
-- local function setAlive(field, cells)
--     for _, cell in ipairs(cells) do
--         local r = cell[1]
--         local c = cell[2]
--         if field[r] and field[r][c] then
--             field[r][c] = 1
--         end
--     end
-- end

-- Подсчет живых соседей
local function countNeighbors(field, row, col, rows, cols)
    local count = 0

    for dr = -1, 1 do
        for dc = -1, 1 do
            if not (dr == 0 and dc == 0) then
                local nr = row + dr
                local nc = col + dc

                if nr >= 1 and nr <= rows and nc >= 1 and nc <= cols then
                    count = count + field[nr][nc]
                end
            end
        end
    end

    return count
end

-- Один шаг симуляции
local function nextGeneration(current, nextField, rows, cols)
    for i = 1, rows do
        for j = 1, cols do
            local neighbors = countNeighbors(current, i, j, rows, cols)

            if current[i][j] == 1 then
                -- Живая клетка
                if neighbors == 2 or neighbors == 3 then
                    nextField[i][j] = 1
                else
                    nextField[i][j] = 0
                end
            else
                -- Мертвая клетка
                if neighbors == 3 then
                    nextField[i][j] = 1
                else
                    nextField[i][j] = 0
                end
            end
        end
    end
end

-- Вывод поля в консоль
local function printField(field, rows, cols, step)
    io.write("\27[2J\27[H") -- очистка экрана (работает во многих терминалах)
    print("Поколение: " .. step)

    for i = 1, rows do
        for j = 1, cols do
            if field[i][j] == 1 then
                io.write("■")
            else
                io.write("·")
            end
        end
        io.write("\n")
    end
end

-- Небольшая пауза
local function sleep(seconds)
    local start = os.clock()
    while os.clock() - start < seconds do end
end

-- ==============================
-- Основная программа
-- ==============================

local current = createField(ROWS, COLS)
local nextField = createField(ROWS, COLS)

-- Начальная фигура: "глайдер"
local startCells = {
    {2, 3},
    {3, 4},
    {4, 2},
    {4, 3},
    {4, 4}
}

setAlive(current, startCells)

for step = 1, STEPS do
    printField(current, ROWS, COLS, step)
    nextGeneration(current, nextField, ROWS, COLS)

    -- Меняем поля местами, чтобы не создавать массив заново
    current, nextField = nextField, current

    sleep(DELAY)
end