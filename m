Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161028Ab3AXUlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:41:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34946 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030184Ab3AXUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:41:38 -0500
Date: Thu, 24 Jan 2013 12:41:18 -0800
From: tip-bot for Maarten Lankhorst <maarten.lankhorst@canonical.com>
Message-ID: <tip-73b664ceb5f815c38def1c68912b83f83455e9eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
In-Reply-To: <50A612AA.7040206@canonical.com>
References: <50A612AA.7040206@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/dma-debug: Bump PREALLOC_DMA_DEBUG_ENTRIES
Git-Commit-ID: 73b664ceb5f815c38def1c68912b83f83455e9eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:41:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73b664ceb5f815c38def1c68912b83f83455e9eb
Gitweb:     http://git.kernel.org/tip/73b664ceb5f815c38def1c68912b83f83455e9eb
Author:     Maarten Lankhorst <maarten.lankhorst@canonical.com>
AuthorDate: Fri, 16 Nov 2012 11:17:14 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 17:34:18 +0100

x86/dma-debug: Bump PREALLOC_DMA_DEBUG_ENTRIES

I ran out of free entries when I had CONFIG_DMA_API_DEBUG
enabled. Some other archs seem to default to 65536, so increase
this limit for x86 too.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Link: http://lkml.kernel.org/r/50A612AA.7040206@canonical.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
----
---
 arch/x86/kernel/pci-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 0f5dec5..872079a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -56,7 +56,7 @@ struct device x86_dma_fallback_dev = {
 EXPORT_SYMBOL(x86_dma_fallback_dev);
 
 /* Number of entries preallocated for DMA-API debugging */
-#define PREALLOC_DMA_DEBUG_ENTRIES       32768
+#define PREALLOC_DMA_DEBUG_ENTRIES       65536
 
 int dma_set_mask(struct device *dev, u64 mask)
 {
