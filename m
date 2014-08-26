Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbaHZXpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:45:25 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:45253 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbaHZXpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:45:22 -0400
From: David Riley <davidriley@chromium.org>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        David Riley <davidriley@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Anton Vorontsov <anton@enomsg.org>,
        Marc Carino <marc.ceeeee@gmail.com>, Anders Berg <anders.berg@lsi.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jamie Lentin <jm@lentin.co.uk>, Doug Anderson <dianders@chromium.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH v1 0/1] gpio-restart restart handler
Date: Tue, 26 Aug 2014 16:45:04 -0700
Message-Id: <1409096705-24290-1-git-send-email-davidriley@chromium.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver builds upon Guenter Roeck's kernel restart handler patchset
to add a driver which registers a GPIO-based restart handler which restarts
the system by toggling a GPIO.

Changes are based off 3.17-rc2 with the following patches from v7 of
Guenter's patchset:
https://patchwork.kernel.org/patch/4746721/
https://patchwork.kernel.org/patch/4746731/
https://patchwork.kernel.org/patch/4747011/
https://patchwork.kernel.org/patch/4746741/
https://patchwork.kernel.org/patch/4746861/

David Riley (1):
  power: Add simple gpio-restart driver

 .../devicetree/bindings/gpio/gpio-restart.txt      |  48 +++++++
 drivers/power/reset/Kconfig                        |   8 ++
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/gpio-restart.c                 | 142 +++++++++++++++++++++
 4 files changed, 199 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-restart.txt
 create mode 100644 drivers/power/reset/gpio-restart.c

-- 
2.0.0

