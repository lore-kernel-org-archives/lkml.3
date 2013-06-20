Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161094Ab3FTQoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:44:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56797 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161062Ab3FTQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:44:07 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: nico@fluxnic.net, cov@codeaurora.org, marc.zyngier@arm.com,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 0/2] ARM: Remove any correlation between IPC and BogoMips value
Date: Thu, 20 Jun 2013 17:43:30 +0100
Message-Id: <1371746612-23950-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is version two of the patches I originally posted here:

  http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166728.html

Comments received there largely confirmed that it's not possible to choose
an `obviously bogus' value for BogoMIPs, so instead I've bitten the bullet
and removed the line altogether.

In the meantime, I've only had one complaint this month about BogoMIPs
being wrong, so perhaps the initial posting served some purpose without
even being merged!

Comments welcome,

Will


Will Deacon (2):
  ARM: delay: don't bother reporting bogomips in /proc/cpuinfo
  init: calibrate: don't print out bogomips value on boot

 arch/arm/kernel/setup.c |  9 ---------
 arch/arm/kernel/smp.c   | 13 ++-----------
 init/calibrate.c        |  8 +++-----
 3 files changed, 5 insertions(+), 25 deletions(-)

-- 
1.8.2.2

