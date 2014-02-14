Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaBNEAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:00:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47918 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaBNEAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:00:11 -0500
Date: Thu, 13 Feb 2014 20:00:00 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-3be5588ad5c2628c8aa4a578bcbb114fa2b49260@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391845930-28580-13-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-13-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] initconst: Fix initconst mistake in dcdbas
Git-Commit-ID: 3be5588ad5c2628c8aa4a578bcbb114fa2b49260
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 20:00:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3be5588ad5c2628c8aa4a578bcbb114fa2b49260
Gitweb:     http://git.kernel.org/tip/3be5588ad5c2628c8aa4a578bcbb114fa2b49260
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:52:09 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:14:54 -0800

initconst: Fix initconst mistake in dcdbas

const must be __initconst.

Cc: Douglas_Warzecha@dell.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-13-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/firmware/dcdbas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 1b5e8e4..7160c43 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -584,7 +584,7 @@ static struct platform_driver dcdbas_driver = {
 	.remove		= dcdbas_remove,
 };
 
-static const struct platform_device_info dcdbas_dev_info __initdata = {
+static const struct platform_device_info dcdbas_dev_info __initconst = {
 	.name		= DRIVER_NAME,
 	.id		= -1,
 	.dma_mask	= DMA_BIT_MASK(32),
