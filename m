Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaF0NQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:16:42 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:63048 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaF0NQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:16:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jon Masters <jonathan@jonmasters.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper function.
Date: Fri, 27 Jun 2014 15:16:28 +0200
Message-ID: <7528887.J1DnSBg239@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140627124949.GR26276@arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com> <6381366.2IfqZj1r0B@wuerfel> <20140627124949.GR26276@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ugG0KX+6HUDmdE8jkIl+85sVDi42YfgJn4nkgIRJFMv
 UPzoIK/2EXtB8mjwmFUG+DqR4BCG3GoGtf12QF/wKX1iu8WNCr
 qs2v626+6ufCNCrpim2hJTba5oBSQYM+BuhDog6BA7u4M8QHi+
 oJigPL2IstLEi4VxiE8XsSVi7lk0PV/xFT8SWZwek6IDdUm/jy
 FqzVyUofSz8Xi83VPBHUMrC++lkXJGSnX1/FJM28h2LpubJ1BA
 O46+pfhJQ9ueATWYWwSGRuV2NzevJhjp5CpQd8XbVtsA+l+i7f
 bNSphIQNJezzyJ+XnsXmFr+lktOe5DDppgodiv/2TbxP0xAqZO
 jyn5InxIUEAk4KZY0de0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2014 13:49:49 Will Deacon wrote:
> On Fri, Jun 27, 2014 at 12:03:34PM +0100, Arnd Bergmann wrote:
> > On Thursday 26 June 2014 19:44:21 Rob Herring wrote:
> > > I don't agree arm32 is harder than microblaze. Yes, converting ALL of
> > > arm would be, but that is not necessary. With Liviu's latest branch
> > > the hacks I previously needed are gone (thanks!), and this is all I
> > > need to get Versatile PCI working (under QEMU):
> > 
> > I meant converting all of arm32 would be harder, but I agree we don't
> > have to do it. It would be nice to convert all of the drivers/pci/host
> > drivers though, iow all multiplatform-enabled ones, and leaving the
> > current arm32 pci implementation for the platforms we don't want to
> > convert to multiplatform anyway (footbridge, iop, ixp4xx, ks8695 (?),
> > pxa, sa1100).
> 
> I'm more than happy to convert the generic host controller we merged
> recently, but I'd probably want the core changes merged first so that I
> know I'm not wasting my time!

That is definitely fine with me, but it's Bjorn's decision.

	Arnd
