Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3BPNwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 08:52:38 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:43263 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3BPNwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 08:52:37 -0500
Date: Sat, 16 Feb 2013 08:52:34 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, js1304@gmail.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v6 3/3] ARM: mm: use static_vm for managing static mapped
 areas
In-Reply-To: <20130216125205.GO17833@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.03.1302160851510.6419@syhkavp.arg>
References: <1360142010-10598-1-git-send-email-iamjoonsoo.kim@lge.com> <1360142010-10598-4-git-send-email-iamjoonsoo.kim@lge.com> <201302161249.08597.arnd@arndb.de> <20130216125205.GO17833@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2013, Russell King - ARM Linux wrote:

> On Sat, Feb 16, 2013 at 12:49:08PM +0000, Arnd Bergmann wrote:
> > 8<-----
> > ARM: mm: remove unused variables in pci_reserve_io
> > 
> > Patch "ARM: 7646/1: mm: use static_vm for managing static mapped areas"
> > removed code from pci_reserve_io but left variable declarations
> > in place that are now unused, as gcc correctly warns.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> > index c6fe15a..c6d45c8 100644
> > --- a/arch/arm/mm/mmu.c
> > +++ b/arch/arm/mm/mmu.c
> > @@ -901,8 +901,6 @@ static void __init fill_pmd_gaps(void)
> >  #if defined(CONFIG_PCI) && !defined(CONFIG_NEED_MACH_IO_H)
> >  static void __init pci_reserve_io(void)
> >  {
> > -	struct vm_struct *vm;
> > -	unsigned long addr;
> >  	struct static_vm *svm;
> >  
> >  	svm = find_static_vm_vaddr((void *)PCI_IO_VIRT_BASE);
> 
> I already have such a patch in my tree - may not have pushed it out
> as I've been ill (and am still recovering.)

OK, disregard my previous ACK then.


Nicolas
