Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab3BFQcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:32:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36730 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3BFQcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:32:22 -0500
Date: Wed, 6 Feb 2013 16:30:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-tegra@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/14] ARM: pci: Keep pci_common_init() around after
	init
Message-ID: <20130206163041.GG17833@n2100.arm.linux.org.uk>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <1357764194-12677-7-git-send-email-thierry.reding@avionic-design.de> <20130205204147.GA29726@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205204147.GA29726@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 09:41:48PM +0100, Thierry Reding wrote:
> On Wed, Jan 09, 2013 at 09:43:06PM +0100, Thierry Reding wrote:
> > When using deferred driver probing, PCI host controller drivers may
> > actually require this function after the init stage.
> > 
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> >  arch/arm/kernel/bios32.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Russell,
> 
> Can this patch and patch 7 (ARM: pci: Allow passing per-controller
> private data) of this series be applied for 3.9? Thomas uses them in his
> Marvell PCIe series as well and it would allow to reduce the complexity
> of the dependencies.

It'll need to go into the patch system in that case...
