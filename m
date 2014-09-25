Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaIYJEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:04:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55425 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777AbaIYJEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:04:02 -0400
Date: Thu, 25 Sep 2014 10:04:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
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
Message-ID: <20140925090406.GD20043@arm.com>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
 <1411498874-9864-10-git-send-email-Liviu.Dudau@arm.com>
 <20140924164304.GF1994@e106497-lin.cambridge.arm.com>
 <20140924173109.GA20416@google.com>
 <20140924175330.GI1994@e106497-lin.cambridge.arm.com>
 <20140924180119.GN16244@arm.com>
 <20140925085432.GL1994@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925085432.GL1994@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 09:54:32AM +0100, Liviu Dudau wrote:
> On Wed, Sep 24, 2014 at 07:01:19PM +0100, Will Deacon wrote:
> > On Wed, Sep 24, 2014 at 06:53:31PM +0100, Liviu Dudau wrote:
> > > Thanks again and sorry for lack of thorough testing. I still haven't managed
> > > to get a cross compiler for sparc and as I don't run Ubuntu or debian the
> > > make.cross script doesn't work for me.
> > 
> >   https://www.kernel.org/pub/tools/crosstool/
> > 
> > No libc, but good enough for building the kernel. I've asked for an aarch64
> > compiler there for a while, but it didn't materialise for some reason.
> 
> I'm familiar with crosstool and busybox uses a variant of crosstool-ng, but
> it currently fails with "configure: error: cannot compute suffix of object files: cannot compile"
> on the stage2 of the compilation.

Did you even follow the link? There are binary toolchains hosted there --
you don't have to build anything yourself if you don't want to.

Will
