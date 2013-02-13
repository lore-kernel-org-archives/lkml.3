Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260Ab3BMXLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:11:40 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:52658 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3BMXLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:11:38 -0500
Date: Thu, 14 Feb 2013 00:11:33 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130214001133.77e6ba06@skate>
In-Reply-To: <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
	<1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Grant Likely,

On Wed, 13 Feb 2013 22:59:50 +0000, Grant Likely wrote:

> There isn't a whole lot of value in this patch without another user.
> I'll need to see the other patches that make use of this.

See the proposed Marvell PCIe driver and Tegra PCIe driver:
 http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149232.html
 http://lists.infradead.org/pipermail/linux-arm-kernel/2013-January/140649.html

Both Thierry (doing the Tegra PCIe driver) and myself (doing the
Marvell PCIe driver) already have fairly long patch series to add
support for the PCIe interfaces in our respective SoC. In order to ease
the process of getting those merged, we'd like to get some of the
base functions we depend on to be merged first, so that our patch
series become a bit smaller and therefore more manageable. My Marvell
PCIe patch series already has 32 patches (including the ones we are
currently discussing), and I will need even more patches for the
upcoming fourth version (due to additional comments made during the
review of the third version of the patch set).

So, it would really be helpful if this base infrastructure, for which
users already exist in the form of submitted patches, that have already
gone through multiple iterations, could be merged.

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
