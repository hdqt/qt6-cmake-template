#include "Dummy.hpp"

/* STL includes */

/* Libraries includes */
#include <gtest/gtest.h>

/* Qt includes */

/* Project includes */

using namespace testing;

class DummyTest : public Test
{
public:
    DummyTest() = default;

    virtual ~DummyTest() = default;

    void SetUp() override;

    void TearDown() override;

    std::shared_ptr<Dummy> createUut();
};

void DummyTest::SetUp()
{

}

void DummyTest::TearDown()
{

}

std::shared_ptr<Dummy> DummyTest::createUut()
{
    return std::make_shared<Dummy>();
}

TEST_F(DummyTest, creationTest)
{
    auto uut = createUut();
    EXPECT_NE(nullptr, uut);
}
