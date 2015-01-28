Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbbA2Poc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:44:32 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:46162 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754737AbbA2Po3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:44:29 -0500
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <gregkh@linuxfoundation.org>
CC: <robh+dt@kernel.org>, <mark.rutland@arm.com>, <arnd@arndb.de>,
        <gnomes@lxorguk.ukuu.org.uk>, <peter@hurleysoftware.com>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>, <jslaby@suse.cz>,
        <heiko@sntech.de>, <jason@lakedaemon.net>, <florian.vaussard@epfl.ch>,
        <andrew@lunn.ch>, <hytszk@gmail.com>, <antonynpavlov@gmail.com>,
        <shawn.guo@linaro.org>, <orsonzhai@gmail.com>,
        <geng.ren@spreadtrum.com>, <zhizhou.zhang@spreadtrum.com>,
        <lanqing.liu@spreadtrum.com>, <zhang.lyra@gmail.com>,
        <wei.qiao@spreadtrum.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <linux-api@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v10 0/2] Add Spreadtrum SoC bindings and serial driver support
Date: Wed, 28 Jan 2015 19:08:42 +0800
Message-ID: <1422443324-25082-1-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <sc9836-serial-v10>
References: <sc9836-serial-v10>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.142]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 SHMBX02.spreadtrum.com (10.0.1.204)
X-MAIL: SHSQR01.spreadtrum.com t0SB9rOE024369
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v9:
	- Added SUPPORT_SYSRQ definition for sprd serial

Changes from v8:
	- Removed a few unuseful code lines.

Chunyan Zhang (2):
  Documentation: DT: Add bindings for Spreadtrum SoC Platform
  tty/serial: Add Spreadtrum sc9836-uart driver support

 Documentation/devicetree/bindings/arm/sprd.txt     |   11 +
 .../devicetree/bindings/serial/sprd-uart.txt       |    7 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/tty/serial/Kconfig                         |   18 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/sprd_serial.c                   |  793 ++++++++++++++++++++
 include/uapi/linux/serial_core.h                   |    3 +
 7 files changed, 834 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
 create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt
 create mode 100644 drivers/tty/serial/sprd_serial.c

-- 
1.7.9.5

