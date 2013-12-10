Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3LJTan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:30:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44008 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3LJTaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:30:39 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 0/2] mm: memblock: Couple of kbuild fixes after the memblock series
Date: Tue, 10 Dec 2013 14:29:56 -0500
Message-ID: <1386703798-26521-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Thanks to kbuild which almost covers all the architectures builds, couple
of build related issues poped up after the memblock series applied [1]

This series tries to address those build issues.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Grygorii Strashko (2):
  mm/ARM: dma: fix conflicting types for 'arm_dma_zone_size'
  mm/memblock: fix buld of "cris" arch

 arch/arm/include/asm/dma.h |    2 +-
 include/linux/bootmem.h    |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Regards,
Santosh

[1] https://lkml.org/lkml/2013/12/9/715 
-- 
1.7.9.5

