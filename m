Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaJHKgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:36:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55204 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaJHKgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:36:07 -0400
Date: Wed, 8 Oct 2014 12:36:00 +0200
From: Robert Richter <rric@kernel.org>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
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
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH v13 00/12] Support for creating generic PCI host bridges
 from DT
Message-ID: <20141008103600.GS20170@rric.localhost>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
 <20140929194335.GA13747@google.com>
 <20140930103942.GO841@e106497-lin.cambridge.arm.com>
 <20140930161805.GB5625@google.com>
 <20140930165431.GV841@e106497-lin.cambridge.arm.com>
 <20141008074428.GD20256@rric.localhost>
 <20141008091321.GC4652@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008091321.GC4652@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.10.14 10:13:21, Liviu Dudau wrote:
> On Wed, Oct 08, 2014 at 08:44:28AM +0100, Robert Richter wrote:
> > I assume pci/host-generic is the latest now with this issue fixed as
> > the commit date is 2014-10-01 past you message above, right? So is it
> > ok to rebase our host controller driver onto pci/host-generic or will
> > there be further updates or any other branch that is newer?
> 
> You can rebase either on top of Bjorn's next branch or use linux-next. Hope to
> see it in v3.18 soon.

Thanks Liviu. So I will use pci/host-generic which is what is in
pci/next:

 d1e6dc91b532 arm64: Add architectural support for PCI

-Robert
