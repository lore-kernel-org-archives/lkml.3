Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbaIBXEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:04:04 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35722 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaIBXEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:04:01 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 0/3] clk: zynq: Clean up
Date: Tue,  2 Sep 2014 16:02:06 -0700
Message-Id: <1409698929-30143-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

triggered by that discussion whether checkpatch should be used to check
files, I ran checkpatch on Zynq's clock code. A few of the reported
issues I found worth fixing.

	Thanks,
	Sören

Soren Brinkmann (3):
  clk: zynq: Remove unnecessary OOM message
  clk: zynq: Remove pointless return at end of void function
  clk: zynq: Move const initdata into correct code section

 drivers/clk/zynq/clkc.c | 30 ++++++++++++++----------------
 drivers/clk/zynq/pll.c  |  4 +---
 2 files changed, 15 insertions(+), 19 deletions(-)

-- 
2.1.0.1.g27b9230

