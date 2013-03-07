Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093Ab3CGNXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:23:38 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:42312 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab3CGNXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:23:35 -0500
Message-ID: <513894E3.1070206@slimlogic.co.uk>
Date: Thu, 07 Mar 2013 13:23:47 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ian Lartey <ian@slimlogic.co.uk>
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        linus.walleij@linaro.org, cooloney@gmail.com, rpurdie@rpsys.net,
        sameo@linux.intel.com, wim@iguana.be, lgirdwood@gmail.com,
        gg@slimlogic.co.uk, j-keerthy@ti.com, ldewangan@nvidia.com,
        t-kristo@ti.com
Subject: [PATCH v8 0/12] Palmas Updates
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
In-Reply-To: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds to the support for the Palmas iseries of PMIC chips.

Some of the patches have previously been submitted individually.
The DT bindings doc has been added first due to comments that it was 
missing.

Patches based on linux-next-20130306

mfd: DT bindings for the palmas family MFD
mfd: palmas: is_palmas_charger needed by multiple driv
mfd: palmas add variant and OTP detection
regulator: palmas correct dt parsing
watchdog: add Palmas Watchdog support
watchdog: Kconfig for Palmas watchdog
gpio: palmas: add in GPIO support for palmas charger
gpio: palmas: Enable DT support for palmas gpio
leds: Add support for Palmas LEDs
leds: Kconfig for Palmas LEDs
clk: add a clock driver for palmas
clk: Kconfig for Palmas clock driver

  .../devicetree/bindings/clock/palmas-clk.txt       |   25 +
  .../devicetree/bindings/gpio/gpio-palmas.txt       |   21 +
  .../devicetree/bindings/input/palmas-pwrbutton.txt |   22 +
  .../devicetree/bindings/leds/leds-palmas.txt       |   35 ++
  Documentation/devicetree/bindings/mfd/palmas.txt   |   70 +++
  .../devicetree/bindings/regulator/palmas-pmic.txt  |  168 ++++++
  .../devicetree/bindings/rtc/palmas-rtc.txt         |   22 +
  .../devicetree/bindings/watchdog/palmas-wdt.txt    |   22 +
  drivers/clk/Kconfig                                |    8 +
  drivers/clk/Makefile                               |    1 +
  drivers/clk/clk-palmas.c                           |  268 ++++++++++
  drivers/gpio/gpio-palmas.c                         |   90 +++-
  drivers/leds/Kconfig                               |    9 +
  drivers/leds/Makefile                              |    1 +
  drivers/leds/leds-palmas.c                         |  560 
++++++++++++++++++++
  drivers/mfd/palmas.c                               |  103 +++-
  drivers/regulator/palmas-regulator.c               |   36 +-
  drivers/watchdog/Kconfig                           |    8 +
  drivers/watchdog/Makefile                          |    1 +
  drivers/watchdog/palmas_wdt.c                      |  170 ++++++
  include/linux/mfd/palmas.h                         |  119 ++++-
  21 files changed, 1703 insertions(+), 56 deletions(-)
  create mode 100644 Documentation/devicetree/bindings/clock/palmas-clk.txt
  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-palmas.txt
  create mode 100644 
Documentation/devicetree/bindings/input/palmas-pwrbutton.txt
  create mode 100644 Documentation/devicetree/bindings/leds/leds-palmas.txt
  create mode 100644 Documentation/devicetree/bindings/mfd/palmas.txt
  create mode 100644 
Documentation/devicetree/bindings/regulator/palmas-pmic.txt
  create mode 100644 Documentation/devicetree/bindings/rtc/palmas-rtc.txt
  create mode 100644 
Documentation/devicetree/bindings/watchdog/palmas-wdt.txt
  create mode 100644 drivers/clk/clk-palmas.c
  create mode 100644 drivers/leds/leds-palmas.c
  create mode 100644 drivers/watchdog/palmas_wdt.c
