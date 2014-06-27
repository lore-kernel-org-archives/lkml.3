Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaF0Nij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:38:39 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:57370 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751972AbaF0Nig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:38:36 -0400
Date: Fri, 27 Jun 2014 14:38:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jon Masters <jonathan@jonmasters.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140627133821.GI15296@arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <6381366.2IfqZj1r0B@wuerfel>
 <20140627124949.GR26276@arm.com>
 <7528887.J1DnSBg239@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7528887.J1DnSBg239@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 02:16:28PM +0100, Arnd Bergmann wrote:
> On Friday 27 June 2014 13:49:49 Will Deacon wrote:
> > On Fri, Jun 27, 2014 at 12:03:34PM +0100, Arnd Bergmann wrote:
> > > On Thursday 26 June 2014 19:44:21 Rob Herring wrote:
> > > > I don't agree arm32 is harder than microblaze. Yes, converting ALL of
> > > > arm would be, but that is not necessary. With Liviu's latest branch
> > > > the hacks I previously needed are gone (thanks!), and this is all I
> > > > need to get Versatile PCI working (under QEMU):
> > > 
> > > I meant converting all of arm32 would be harder, but I agree we don't
> > > have to do it. It would be nice to convert all of the drivers/pci/host
> > > drivers though, iow all multiplatform-enabled ones, and leaving the
> > > current arm32 pci implementation for the platforms we don't want to
> > > convert to multiplatform anyway (footbridge, iop, ixp4xx, ks8695 (?),
> > > pxa, sa1100).
> > 
> > I'm more than happy to convert the generic host controller we merged
> > recently, but I'd probably want the core changes merged first so that I
> > know I'm not wasting my time!
> 
> That is definitely fine with me, but it's Bjorn's decision.

Or the changes to the generic host controller can be part of Liviu's
patch series (maybe together with other PCI host drivers like
designware, as time allows).

-- 
Catalin
