Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaAaAwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:52:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:7938 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbaAaAwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:52:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,753,1384329600"; 
   d="scan'208";a="467565327"
From: nitin.a.kamble@intel.com
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        nitin.a.kamble@intel.com
Subject: [PATCH] a Kconfig fix
Date: Thu, 30 Jan 2014 16:50:09 -0800
Message-Id: <1391129410-54548-1-git-send-email-nitin.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

This is pull request with a fix for Kconfig dependency issue. It fixes
a build failure when the kernel configuration option GENERIC_IRQ_CHIP
is enabled without enabling the IRQ_DOMAIN config option in the kernel
configuration.

Thanks,
Nitin

Nitin A Kamble (1):
  irq: fix a Kconfig dependency

 kernel/irq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

-- 
1.8.1.4

