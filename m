Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbaITCYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 22:24:47 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64367 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaITCYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 22:24:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v11 07/10] OF: Introduce helper function for getting PCI domain_nr
Date: Sat, 20 Sep 2014 04:24:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        "linux-arch" <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com> <1411003825-21521-8-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1411003825-21521-8-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409200424.20538.arnd@arndb.de>
X-Provags-ID: V02:K0:z9RvVgGGjVDwnwfbopS5u1dbki0QdjOIvgWiEO8y1QZ
 cGH2QkvcHw7hFp8AMYJ4GIiSg2R/fzEhvg8WbnSukHQdtDfTR4
 vJEf+9EI16+ayDJ/T5rgkR67/FoJyKMBJbXeI/5MVC1jPWOuq9
 9tW4LfaTegKNegiY//W6D8YRcywG42kpmsXOu6Fy8l7BKMLylO
 IMnLvpE3/2A3T5do64oQxRreqoZ3IRaneqWQWePoQryhTmVmVo
 ymPVO234OmrbhrtJ4V050iDUBXXY1/BLVWJpgT+xXiQGCWv+I6
 yhi+h2WBZKdXart/rUDTFxepj0AzQhNYt3nl1R11jD21D5tfx0
 MRGCsKDc0DOVeIsJIvj4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 September 2014, Liviu Dudau wrote:
> 
> Add of_pci_get_domain_nr() to retrieve the PCI domain number
> of a given device from DT. If the information is not present,
> the function can be requested to allocate a new domain number.
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

This is more elaborate than I remember it, and while the simpler
version (which potentially resulted in a conflict for inconsistent
DTs) was fine, this one also seems ok.

Acked-by: Arnd Bergmann <arnd@arndb.de>
