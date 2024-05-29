#pragma once

/* STL includes */

/* Libraries includes */
#include <gmock/gmock.h>

/* Qt includes */

/* Project includes */
#include "IDummy.hpp"

class MockIDummy : public IDummy
{
public:
    virtual ~MockIDummy() override = default;

    MOCK_METHOD0(greeting, void());

    static std::shared_ptr<MockIDummy> create()
    {
        return std::shared_ptr<::testing::StrictMock<MockIDummy>>();
    }
};
