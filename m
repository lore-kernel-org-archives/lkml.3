Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaHMKdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:33:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35771 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaHMKdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:33:16 -0400
Date: Wed, 13 Aug 2014 11:33:11 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 12/12] PCI: Introduce pci_remap_iospace() for
 remapping PCI I/O bus resources into CPU space
Message-ID: <20140813103311.GQ25761@e106497-lin.cambridge.arm.com>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860725-25202-13-git-send-email-Liviu.Dudau@arm.com>
 <20140813100118.GC18495@arm.com>
MIME-Version: 1.0
In-Reply-To: <20140813100118.GC18495@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 13 Aug 2014 10:33:12.0375 (UTC) FILETIME=[FBB31C70:01CFB6E1]
X-MC-Unique: 114081311331305701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 11:01:18AM +0100, Catalin Marinas wrote:
> On Tue, Aug 12, 2014 at 05:25:25PM +0100, Liviu Dudau wrote:
> > Introduce a default implementation for remapping PCI bus I/O resources
> > onto the CPU address space. Architectures with special needs may
> > provide their own version, but most should be able to use this one.
> > 
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> I guess you could have added the generic pgprot_device definition to
> this patch and the arm64 specific one in the separate arm64 PCIe support
> (and one less patch in total). But not a big issue either way.

I went by the established history on that file, where a new interface gets
introduced together with its use. I guess it makes backing out the change
much easier?

Best regards,
Liviu

> 
> -- 
> Catalin

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

