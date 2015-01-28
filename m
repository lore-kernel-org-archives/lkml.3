Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbbA1C4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:56:16 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:54027 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755028AbbA1C4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:56:15 -0500
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
Subject: [PATCH v9 0/2] Add Spreadtrum SoC bindings and serial driver support
Date: Wed, 28 Jan 2015 10:47:39 +0800
Message-ID: <1422413261-17184-1-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <sc9836-serial-v9>
References: <sc9836-serial-v9>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.142]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 SHMBX02.spreadtrum.com (10.0.1.204)
X-MAIL: SHSQR01.spreadtrum.com t0S2n2YW039766
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v8:
	- Moved a few unuseful code lines.

Chunyan Zhang (2):
  Documentation: DT: Add bindings for Spreadtrum SoC Platform
  tty/serial: Add Spreadtrum sc9836-uart driver support

 Documentation/devicetree/bindings/arm/sprd.txt     |   11 +
 .../devicetree/bindings/serial/sprd-uart.txt       |    7 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/tty/serial/Kconfig                         |   18 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/sprd_serial.c                   |  789 ++++++++++++++++++++
 include/uapi/linux/serial_core.h                   |    3 +
 7 files changed, 830 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
 create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt
 create mode 100644 drivers/tty/serial/sprd_serial.c

-- 
1.7.9.5

