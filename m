Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3FMQhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:37:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57954 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3FMQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:37:40 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Dinh Nguyen <dinguyen@altera.com>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 0/4] Zynq: Support more boards
Date: Thu, 13 Jun 2013 09:37:14 -0700
Message-Id: <1371141438-16553-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just another respin. Still depending on armsoc/zynq/clk

	Sören

v3:
 - adding patch to use 'status' property for UART nodes
 - dropping board specific compat string in the Zed dts

v2:
 - adding patch to remove board specific compat strings from the BSP
 - adding patch adding Zed support

Soren Brinkmann (4):
  arm: zynq: Remove board specific compatibility string
  arm: dt: zynq: Use 'status' property for UART nodes
  arm: dt: zynq: Add support for the zc706 platform
  arm: dt: zynq: Add support for the zed platform

 arch/arm/boot/dts/Makefile       |  4 +++-
 arch/arm/boot/dts/zynq-7000.dtsi |  2 ++
 arch/arm/boot/dts/zynq-zc702.dts |  6 +++++-
 arch/arm/boot/dts/zynq-zc706.dts | 35 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/zynq-zed.dts   | 35 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-zynq/common.c      |  1 -
 6 files changed, 80 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/dts/zynq-zc706.dts
 create mode 100644 arch/arm/boot/dts/zynq-zed.dts

-- 
1.8.3

