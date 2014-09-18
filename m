Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbaIRVnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:43:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36108 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbaIRVnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:43:16 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 0/3] Krait VFP fixes
Date: Thu, 18 Sep 2014 14:43:09 -0700
Message-Id: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes allow us to support VFP correctly on Krait processors.
They also fix short vector emulation for Cortex-A15 and Krait.

Stepan Moskovchenko (1):
  arm: vfp: Bounce undefined instructions in vectored mode

Stephen Boyd (2):
  ARM: vfp: Workaround bad MVFR1 register on some Kraits
  ARM: vfp: fix VFPv3 hwcap detection on non-ARM vfp implementations

 arch/arm/include/asm/cputype.h | 1 +
 arch/arm/include/asm/vfp.h     | 2 +-
 arch/arm/mm/proc-v7.S          | 5 +++--
 arch/arm/vfp/vfphw.S           | 6 ++++++
 arch/arm/vfp/vfpmodule.c       | 7 +++++++
 5 files changed, 18 insertions(+), 3 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

