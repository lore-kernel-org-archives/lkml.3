Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaGNOdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:33:51 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62180 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbaGNOdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:33:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, thierry.reding@gmail.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        ajitpal.singh@st.com
Subject: [PATCH v2 00/11] pwm: Introduce ST's PWM driver
Date: Mon, 14 Jul 2014 15:33:21 +0100
Message-Id: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

I'm pretty sure all of your review comments have been tended to
now.  Some have been fixed-up by myself and re-rolled into the
original set.  The larger changes have been fixed as subsequent
patches for ease of review and history tracking on the internal
kernel.

Kind regards,
Lee

Ajit Pal Singh (4):
  pwm: st: Fix PWM prescaler handling
  pwm: sti: Ensure same period values for all channels
  pwm: sti: Sync between enable/disable calls
  pwm: sti: Remove PWM period table

Lee Jones (7):
  ARM: stih407: Add DT nodes for for PWM
  ARM: stih416: Add Pinctrl settings for PWM
  ARM: stih416: Add DT nodes for PWM
  ARM: stih416-b2020e: Enable PWM on the B2020 Rev-E
  ARM: multi_v7_defconfig: Enable ST's PWM driver
  pwm: sti: Add new driver for ST's PWM IP
  pwm: sti: Supply Device Tree binding documentation for ST's PWM IP

 Documentation/devicetree/bindings/pwm/pwm-st.txt |  41 +++
 arch/arm/boot/dts/stih407.dtsi                   |  28 ++
 arch/arm/boot/dts/stih416-b2020e.dts             |  10 +
 arch/arm/boot/dts/stih416-pinctrl.dtsi           |  50 +++
 arch/arm/boot/dts/stih416.dtsi                   |  44 ++-
 arch/arm/configs/multi_v7_defconfig              |   1 +
 drivers/pwm/Kconfig                              |  10 +
 drivers/pwm/Makefile                             |   1 +
 drivers/pwm/pwm-sti.c                            | 418 +++++++++++++++++++++++
 9 files changed, 602 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-st.txt
 create mode 100644 drivers/pwm/pwm-sti.c

-- 
1.8.3.2

