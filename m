Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbbAILdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:33:07 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58619 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbbAILdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:33:05 -0500
Date: Fri, 9 Jan 2015 11:32:55 +0000
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v3 3/4] of/pci: add of_pci_dma_configure() update dma
 configuration
Message-ID: <20150109113254.GA11258@arm.com>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com>
 <20150108160626.GN11583@arm.com>
 <54AEDFED.8060008@ti.com>
 <2057344.eJYxBNosJg@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2057344.eJYxBNosJg@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 10:25:15PM +0000, Arnd Bergmann wrote:
> On Thursday 08 January 2015 14:52:13 Murali Karicheri wrote:
> > 
> > Could you add this as as a follow up patch as I don't have a platformm 
> > that support IOMMU and as such my understanding of the IOMMU is limited?
> > 
> > I can help test the change to make sure it has no side effect on 
> > Keystone that doesn't support IOMMU.
> 
> I think that's fine. Let's get your series done first and add the
> DMA aliases for iommus on top once we have worked out what to do.

Yeah, I'm fine with that too. I think we're going to be working on this for
a while, so doing it bit-by-bit makes a lot of sense.

Will
