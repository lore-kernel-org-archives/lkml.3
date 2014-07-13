Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaGMO7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:59:20 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaGMO7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:59:09 -0400
From: Richard Weinberger <richard@nod.at>
To: tony.luck@intel.com, fenghua.yu@intel.com, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] Remove remaining users of exec domains
Date: Sun, 13 Jul 2014 16:58:56 +0200
Message-Id: <1405263538-27589-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches remove the last two in-tree users of exec domains.
Both seem to be abandoned and historical.
Russel, Tony, are you fine with that? 

The plan is to get rid of exec domains at all. IOW no more register_exec_domain,
no signal translation.
I have a follow up series for that already in my local tree.

Thanks,
//richard

[PATCH 1/2] arm: Remove RISC OS personality
[PATCH 2/2] ia64: Remove Linux/x86 domain support

 arch/arm/kernel/arthur.c          |   94 ------------------------------------
 arch/arm/Kconfig                  |   12 ----
 arch/arm/configs/badge4_defconfig |    1 
 arch/arm/kernel/Makefile          |    1 
 arch/ia64/mm/init.c               |   25 ---------
 5 files changed, 133 deletions(-)

