Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986AbaFIJiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:38:25 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:49740 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701AbaFIJiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:38:21 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 0/5] Add Maxim 77802 PMIC support
Date: Mon,  9 Jun 2014 11:37:45 +0200
Message-Id: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77802 is a PMIC that contains 10 high efficiency Buck regulators,
32 Low-dropout (LDO) regulators, two 32kHz buffered clock outputs,
a Real-Time-Clock (RTC) and a I2C interface to program the individual
regulators, clocks and the RTC.

This series are based on drivers added by Simon Glass to the Chrome OS
kernel and adds support for the Maxim 77802 Power Management IC, their
regulators, clocks, RTC and I2C interface. It is composed of patches:

[PATCH 1/5] mfd: Add driver for Maxim 77802 Power Management IC
[PATCH 2/5] regulator: Add driver for Maxim 77802 PMIC regulators
[PATCH 3/5] clk: Add driver for Maxim 77802 PMIC clocks
[PATCH 4/5] rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
[PATCH 5/5] ARM: dts: Add max77802 device node for exynos5420-peach-pit

Patches 1-4 add support for the different devices and Patch 5 enables
the MAX77802 PMIC on the Exynos5420 based Peach pit board.

Lee,

Patches 2-4 depend on Patch 1 so I think that it makes sense if you take
1-4 through your mfd tree once the relevant maintainers ack the drivers
added to the other subsystems (regulator, clk and rtc).

Patch 5 can go through Kukjin tree since is just DTS changes.

Thanks a lot and best regards,
Javier

-- 
2.0.0.rc2

