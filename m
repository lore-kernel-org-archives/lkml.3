Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3FLO2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:28:04 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:39419 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3FLO2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:28:02 -0400
From: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH 0/2] Enable cc8540 pinctrl DT for uart and i2c v2
Date: Wed, 12 Jun 2013 16:26:33 +0200
Message-Id: <1371047193-14228-1-git-send-email-gabriel.fernandez.st@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

Theses patches enable ccu8540 pintctrl DT for uart and i2c
Modifications from first version:
	- supress &pinctrl_dbx500 phandle.
	- add pintctrl { compatible = "stericsson,db8540-pinctrl"; ...
	- cosmetics.

Gabriel Fernandez (2):
  ARM: u8540: Add Pinctrl Device Tree settings for uart0, uart2
  ARM: u8540: DT: Set pinctrl mapping to i2c0,1,2,4 & 5

 arch/arm/boot/dts/ccu8540-pinctrl.dtsi     | 196 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/ccu8540.dts              |  45 +++++++
 arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi |  95 ++++++++++++++
 include/dt-bindings/pinctrl/nomadik.h      |  36 ++++++
 4 files changed, 372 insertions(+)
 create mode 100644 arch/arm/boot/dts/ccu8540-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi
 create mode 100644 include/dt-bindings/pinctrl/nomadik.h

-- 
1.8.1.1

