Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbbASGSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 01:18:16 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51024 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbASGSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 01:18:14 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 19 Jan 2015 15:19:02 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, mhocko@suse.cz,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: mmotm 2015-01-16-15-50 uploaded
Message-ID: <20150119061902.GC11473@js1304-P5Q-DELUXE>
References: <54b9a3ce.lQ94nh84G4XJawsQ%akpm@linux-foundation.org>
 <20150117064023.GA5743@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150117064023.GA5743@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 10:40:23PM -0800, Guenter Roeck wrote:
> On Fri, Jan 16, 2015 at 03:50:38PM -0800, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2015-01-16-15-50 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> > 
> 
> This version is a bit worse than usual.
> 
> Build results:
> 	total: 133 pass: 113 fail: 20
> Failed builds:
> 	alpha:defconfig
> 	alpha:allmodconfig
> 	m32r:defconfig
> 	m68k:defconfig
> 	m68k:allmodconfig
> 	m68k:sun3_defconfig
> 	m68k:m5475evb_defconfig
> 	microblaze:mmu_defconfig
> 	mips:allmodconfig
> 	parisc:defconfig
> 	parisc:generic-32bit_defconfig
> 	parisc:a500_defconfig
> 	parisc:generic-64bit_defconfig
> 	powerpc:cell_defconfig
> 	powerpc:mpc85xx_defconfig
> 	powerpc:mpc85xx_smp_defconfig
> 	powerpc:cell_defconfig
> 	powerpc:mpc85xx_defconfig
> 	powerpc:mpc85xx_smp_defconfig
> 	sparc32:defconfig
> Qemu tests:
> 	total: 30 pass: 18 fail: 12
> Failed tests:
> 	alpha:alpha_defconfig
> 	microblaze:microblaze_defconfig
> 	microblaze:microblazeel_defconfig
> 	mips:mips_malta_smp_defconfig
> 	mips64:mips_malta64_smp_defconfig
> 	powerpc:ppc_book3s_smp_defconfig
> 	powerpc:ppc64_book3s_smp_defconfig
> 	sh:sh_defconfig
> 	sparc32:sparc_defconfig
> 	sparc32:sparc_smp_defconfig
> 	x86:x86_pc_defconfig
> 	x86_64:x86_64_pc_defconfig
> 
> Details are available at http://server.roeck-us.net:8010/builders; look for the
> 'mmotm' logs.
> 
> Patches identified as bad by bisect (see below for bisect logs):
> 
> 3ecd42e200dc mm/hugetlb: reduce arch dependent code around follow_huge_*
> c824a9dc5e88 mm: account pmd page tables to the process
> 825e778f321e mm/slub: optimize alloc/free fastpath by removing preemption on/off

Hello,

I sent the fix for testing failure due to 825e778f321e.

https://lkml.org/lkml/2015/1/19/17

It would fix this testing failure.

Thanks.
