Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbaDTMkD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 08:40:03 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48555 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaDTMj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 08:39:57 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH -mm 0/2] x86: fix DMA CMA on x86
Date: Sun, 20 Apr 2014 21:39:45 +0900
Message-Id: <1397997587-11021-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series includes two fixes for dma_generic_alloc_coherent(), based
on top of the patchset 'enhance DMA CMA on x86' which has been added
in -mm tree.

Akinobu Mita (2):
  x86: fix dma_generic_alloc_coherent() when CONFIG_DMA_CMA is enabled
  x86: avoid duplicated memset in dma_generic_alloc_coherent()

 arch/x86/kernel/pci-dma.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org
Cc: iommu@lists.linux-foundation.org
-- 
1.8.3.2

