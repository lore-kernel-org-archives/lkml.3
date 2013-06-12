Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3FLQle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:41:34 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42003 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab3FLQld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:41:33 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Dinh Nguyen <dinguyen@altera.com>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 0/3] Zynq: Support more boards
Date: Wed, 12 Jun 2013 09:41:05 -0700
Message-Id: <1371055268-32337-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the zc702 and zed Zynq platforms. The series
depends on armsoc/zynq/clk.
The third patch is a little tricky in terms of the compatibility strings used
since the Zed board is not a Xilinx product. I looked at the Digilent vendor
tree and they use 'xlnx,zynq-zed', so I decided to do the same here. But this
might be a subject for discussion.
https://github.com/Digilent/linux-digilent/blob/master/arch/arm/boot/dts/digilent-zed.dts#L40

	Sören

v2:
 - adding patch to remove board specific compat strings from the BSP
 - adding patch adding Zed support

Soren Brinkmann (3):
  arm: zynq: Remove board specific compatibility string
  arm: dt: zynq: Add support for the zc706 platform
  arm: dt: zynq: Add support for the zed platform

 arch/arm/boot/dts/Makefile       |  4 +++-
 arch/arm/boot/dts/zynq-zc706.dts | 31 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/zynq-zed.dts   | 31 +++++++++++++++++++++++++++++++
 arch/arm/mach-zynq/common.c      |  1 -
 4 files changed, 65 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/boot/dts/zynq-zc706.dts
 create mode 100644 arch/arm/boot/dts/zynq-zed.dts

-- 
1.8.3

