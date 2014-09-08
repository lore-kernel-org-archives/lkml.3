Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaIJQYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:24:36 -0400
Received: from [217.140.108.86] ([217.140.108.86]:60837 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751865AbaIJQYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:24:03 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 12:24:02 EDT
Date: Mon, 8 Sep 2014 15:01:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10] arm64: Add architectural support for PCIe
Message-ID: <20140908140129.GE22717@arm.com>
References: <1410184549-17690-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184549-17690-2-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410184549-17690-2-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 02:55:49PM +0100, Liviu Dudau wrote:
> Use the generic PCI domain and OF functions
> to provide support for PCI Express on arm64.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> [Generic PCI domain support]
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Minor detail: when have I signed this patch off? I'm not the author
(maybe bits of it but I think most of it is yours). However, you can
add:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
