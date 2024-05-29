#pragma once

/* STL includes */

/* Libraries includes */

/* Qt includes */

/* Project includes */
#include "IDummy.hpp"

class Dummy : public IDummy
{
public:
    explicit Dummy();

    virtual ~Dummy() override = default;

    void greeting() override;
};
