Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3JJCbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:31:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:1294 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3JJCbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:31:18 -0400
X-Spam-Score: -100.8
Message-ID: <52561137.3070608@asianux.com>
Date: Thu, 10 Oct 2013 10:30:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
CC: linux390@de.ibm.com, linux-s390@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] s390/arm/arm64: include: asm: atomic.h: use 'unsigned
 int' and 'atomic_t' instead of 'unsigned long' for atomic_*_mask()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For atomic_*_mask(), the 'atomic_t' is 32-bit, so for the 'mask', also
need mach it.


Patch 1/3: s390: include: asm: atomic.h: use 'unsigned int' instead of
'unsigned long' for atomic_*_mask().

Patch 2/3: arm: include: asm: atomic.h: use 'unsigned int' and 'atomic'
instead of 'unsigned long' for atomic_clear_mask().

Patch 3/3: arm64: include: asm: atomic.h: use 'unsigned int' and
'atomic_t' instead of 'unsigned long' for atomic_clear_mask().


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm/include/asm/atomic.h   |   13 +++++++------
 arch/arm64/include/asm/atomic.h |   13 +++++++------
 arch/s390/include/asm/atomic.h  |    4 ++--
 3 files changed, 16 insertions(+), 14 deletions(-)

