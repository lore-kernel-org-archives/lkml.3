Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaIHOE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:04:26 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40469 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaIHOEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:04:22 -0400
Date: Mon, 8 Sep 2014 15:04:15 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
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
Message-ID: <20140908140415.GL27864@e106497-lin.cambridge.arm.com>
References: <1410184549-17690-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184549-17690-2-git-send-email-Liviu.Dudau@arm.com>
 <20140908140129.GE22717@arm.com>
MIME-Version: 1.0
In-Reply-To: <20140908140129.GE22717@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 08 Sep 2014 14:04:16.0958 (UTC) FILETIME=[C71E9DE0:01CFCB6D]
X-MC-Unique: 114090815041904701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 03:01:30PM +0100, Catalin Marinas wrote:
> On Mon, Sep 08, 2014 at 02:55:49PM +0100, Liviu Dudau wrote:
> > Use the generic PCI domain and OF functions
> > to provide support for PCI Express on arm64.
> > 
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > [Generic PCI domain support]
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Minor detail: when have I signed this patch off? I'm not the author
> (maybe bits of it but I think most of it is yours). However, you can
> add:
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

I've took the patch from here: https://lkml.org/lkml/2014/7/14/529

It does have your Signed-off-by, all I did was split it up into the
relevant chunks.

Best regards,
Liviu

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

