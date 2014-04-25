Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaDYDTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 23:19:45 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:64569 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaDYDTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 23:19:09 -0400
X-IronPort-AV: E=Sophos;i="4.97,924,1389772800"; 
   d="scan'208";a="26540278"
From: Zi Shen Lim <zlim@broadcom.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Brown <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>
CC: Zi Shen Lim <zlim@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 0/2] arm64 topology updates
Date: Thu, 24 Apr 2014 20:18:40 -0700
Message-ID: <1398395922-7482-1-git-send-email-zlim@broadcom.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this updated series, I've added Mark Brown's review-by to PATCH 1/2.

I've addressed Mark's comments for PATCH 2/2.
In order not to lose any information from MPIDR bits, we map all
higher affinity levels into "cluster". This approach is similar to
how Mark is handling multi-level clusters in DT.

Many thanks to Mark for review and comments!

Link to initial posting of this series:
    https://lkml.org/lkml/2014/4/22/950

Zi Shen Lim (2):
  arm64, sched: Remove unused mc_capable() and smt_capable()
  arm64: topology: add MPIDR-based detection

 arch/arm64/include/asm/cputype.h  |  2 ++
 arch/arm64/include/asm/topology.h |  3 ---
 arch/arm64/kernel/topology.c      | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 3 deletions(-)

-- 
1.8.4.3

