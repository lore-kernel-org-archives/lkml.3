Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaJHHoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:44:39 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33747 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaJHHog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:44:36 -0400
Date: Wed, 8 Oct 2014 09:44:28 +0200
From: Robert Richter <rric@kernel.org>
To: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
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
Message-ID: <20141008074428.GD20256@rric.localhost>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
 <20140929194335.GA13747@google.com>
 <20140930103942.GO841@e106497-lin.cambridge.arm.com>
 <20140930161805.GB5625@google.com>
 <20140930165431.GV841@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930165431.GV841@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liviu, Bjorn,

On 30.09.14 17:54:31, Liviu Dudau wrote:
> On Tue, Sep 30, 2014 at 05:18:05PM +0100, Bjorn Helgaas wrote:
> > OK, I rebuilt pci/host-generic from scratch.  It consists of your v13
> > patches + Arnd's build fix for pci_pio_to_address() in !CONFIG_OF configs.
> 
> Something went wrong with the integration, patch 02 adds another definition of 
> of_pci_range_to_resource() before it is moved out of the header file for some reason.

I assume pci/host-generic is the latest now with this issue fixed as
the commit date is 2014-10-01 past you message above, right? So is it
ok to rebase our host controller driver onto pci/host-generic or will
there be further updates or any other branch that is newer?

Thanks,

-Robert
