Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaGDJoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:44:46 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37621 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaGDJoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:44:44 -0400
Date: Fri, 4 Jul 2014 10:44:40 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Prabhakar Kushwaha <prabhakar@freescale.com>
Cc: Tanmay Inamdar <tinamdar@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>
Subject: Re: [PATCH] arm64: PCI(e) arch support
Message-ID: <20140704094440.GC6501@e106497-lin.cambridge.arm.com>
References: <1404422876-1160-1-git-send-email-tinamdar@apm.com>
 <53B5F81B.8010801@freescale.com>
MIME-Version: 1.0
In-Reply-To: <53B5F81B.8010801@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 04 Jul 2014 09:44:41.0341 (UTC) FILETIME=[941092D0:01CF976C]
X-MC-Unique: 114070410444112901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 01:40:59AM +0100, Prabhakar Kushwaha wrote:
> Hi Tanmay, Liviu,
> On 7/4/2014 2:57 AM, Tanmay Inamdar wrote:
> > Reposting on request of several people since previously posted one was
> > corrupted.
> >
> > This patch adds the arch support for PCI(e) for arm64. The files
> > added or modified in this patch are based on PCI(e) support in
> > 32bit arm.
> >
> > Please note that this patch is just for the reference. Liviu Dudau from ARM
> > has posted his v8 series of patch to support PCIe in arm64.
> >
> > The patch will apply against 3.13 Linux Kernel
> >
> > Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> >
> 
> do we foresee similar type of changes in u-boot  to support PCI(e) for 
> ARM64.

I'm afraid I'm not familiar with u-boot's support for PCI(e), so I cannot
answer that. As a general matter, ARM has decided to officially support
UEFI as a bootloader for ARMv8 and that already has support for PCI(e),
one only needs a driver for the specific host bridge.

Best regards,
Liviu

> 
> Regards,
> Prabhakar
> 
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

