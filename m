Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaIYIyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:54:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:59732 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaIYIyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:54:39 -0400
Date: Thu, 25 Sep 2014 09:54:32 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Robert Richter <rrichter@cavium.com>
Subject: Re: [PATCH v12 09/12] OF: PCI: Add support for parsing PCI host
 bridge resources from DT
Message-ID: <20140925085432.GL1994@e106497-lin.cambridge.arm.com>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
 <1411498874-9864-10-git-send-email-Liviu.Dudau@arm.com>
 <20140924164304.GF1994@e106497-lin.cambridge.arm.com>
 <20140924173109.GA20416@google.com>
 <20140924175330.GI1994@e106497-lin.cambridge.arm.com>
 <20140924180119.GN16244@arm.com>
MIME-Version: 1.0
In-Reply-To: <20140924180119.GN16244@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 25 Sep 2014 08:54:33.0488 (UTC) FILETIME=[5387E100:01CFD89E]
X-MC-Unique: 114092509543602901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 07:01:19PM +0100, Will Deacon wrote:
> On Wed, Sep 24, 2014 at 06:53:31PM +0100, Liviu Dudau wrote:
> > On Wed, Sep 24, 2014 at 06:31:09PM +0100, Bjorn Helgaas wrote:
> > > On Wed, Sep 24, 2014 at 05:43:04PM +0100, Liviu Dudau wrote:
> > > > Provide a function to parse the PCI DT ranges that can be used to
> > > > create a pci_host_bridge structure together with its associated
> > > > bus.
> > > > 
> > > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > > Cc: Grant Likely <grant.likely@linaro.org>
> > > > Cc: Rob Herring <robh+dt@kernel.org>
> > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > > > [make io_base parameter optional]
> > > > Signed-off-by: Robert Richter <rrichter@cavium.com>
> > > > ---
> > > > Hi Bjorn,
> > > > 
> > > > I have fixed the compilation error that this patch was triggering. I
> > > > have validated that the patch applies to your pci/host-generic branch
> > > > as well as to my series.
> > > 
> > > I applied this to pci/host-generic along with the following patches and
> > > pushed the branch, thanks!
> > 
> > Thanks again and sorry for lack of thorough testing. I still haven't managed
> > to get a cross compiler for sparc and as I don't run Ubuntu or debian the
> > make.cross script doesn't work for me.
> 
>   https://www.kernel.org/pub/tools/crosstool/
> 
> No libc, but good enough for building the kernel. I've asked for an aarch64
> compiler there for a while, but it didn't materialise for some reason.

I'm familiar with crosstool and busybox uses a variant of crosstool-ng, but
it currently fails with "configure: error: cannot compute suffix of object files: cannot compile"
on the stage2 of the compilation.

Best regards,
Liviu

> 
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

