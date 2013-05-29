Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966123Ab3E2Ng0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:36:26 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36559 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935172Ab3E2NgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:36:24 -0400
From: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH 0/4] Introduce ccu8540 uib-v3
Date: Wed, 29 May 2013 15:33:23 +0200
Message-Id: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

This patch set introduces a new board for u8540 platform: ccu8540-uib-v3.




Gabriel Fernandez (4):
  ARM: ux540: Add ccu8540-uib-v3 Device Tree Machine
  ARM: u8540: Add device tree support for lp5521 leds
  ARM: u8540: Add device tree support for bh1780
  ARM: u8540: Add DT probing for SFH7741 Proximity Sensor

 arch/arm/boot/dts/Makefile           |  1 +
 arch/arm/boot/dts/ccu8540-uib-v3.dts | 58 ++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100644 arch/arm/boot/dts/ccu8540-uib-v3.dts

-- 
1.8.1.1

