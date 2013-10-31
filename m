Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3JaQKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:10:30 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44112 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3JaQK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:10:29 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/6] arm: zynq: BSP update
Date: Thu, 31 Oct 2013 09:10:13 -0700
Message-Id: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are a few updates and fixes for the Zynq BSP coming
cherry-picked/ported from the Xilinx vendor tree.

	Sören

Michal Simek (1):
  arm: zynq: Add support for zynq_cpu_kill function

Peter Crosthwaite (1):
  arm: zynq: platsmp: Fix CPU presence check

Soren Brinkmann (4):
  arm: zynq: Invalidate L1 in secondary boot
  arm: zynq: Use of_platform_populate instead of bus_probe
  arm: zynq: Set proper GIC flags
  arm: zynq: headsmp: Move .glbl out of actual code

 arch/arm/mach-zynq/common.c  | 16 ++++++++++------
 arch/arm/mach-zynq/common.h  |  2 ++
 arch/arm/mach-zynq/headsmp.S | 11 ++++++++---
 arch/arm/mach-zynq/platsmp.c | 13 +++++++++++--
 4 files changed, 31 insertions(+), 11 deletions(-)

-- 
1.8.4.1

