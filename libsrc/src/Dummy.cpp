#include "Dummy.hpp"

/* STL includes */

/* Libraries includes */

/* Qt includes */
#include <QDebug>

/* Project includes */

Dummy::Dummy()
{
}

void Dummy::greeting()
{
    qDebug() << "Hello World!!";
}
