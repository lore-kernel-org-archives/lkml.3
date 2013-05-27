Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3E0NcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:32:24 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:42344 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab3E0NcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:32:23 -0400
From: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH 0/3] Enable cc8540 pinctrl DT for uart and i2c
Date: Mon, 27 May 2013 15:30:52 +0200
Message-Id: <1369661455-17839-1-git-send-email-gabriel.fernandez.st@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

Theses patches enable ccu8540 pintctrl DT for uart and i2c

Gabriel Fernandez (3):
  ARM: ux500: use #include syntax to include *.dtsi.
  ARM: u8540: Add Pinctrl Device Tree settings for uart0, uart2
  ARM: u8540: DT: Set pinctrl mapping to i2c0,1,2,4 & 5

 arch/arm/boot/dts/ccu8540-pinctrl.dtsi     | 192 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/ccu8540.dts              |  39 +++++-
 arch/arm/boot/dts/ccu9540.dts              |   2 +-
 arch/arm/boot/dts/dbx5x0.dtsi              |   4 +-
 arch/arm/boot/dts/href.dtsi                |   2 +-
 arch/arm/boot/dts/hrefprev60.dts           |   6 +-
 arch/arm/boot/dts/hrefv60plus.dts          |   6 +-
 arch/arm/boot/dts/snowball.dts             |   2 +-
 arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi |  95 ++++++++++++++
 include/dt-bindings/pinctrl/nomadik.h      |  36 ++++++
 10 files changed, 372 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm/boot/dts/ccu8540-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi
 create mode 100644 include/dt-bindings/pinctrl/nomadik.h

-- 
1.8.1.1

