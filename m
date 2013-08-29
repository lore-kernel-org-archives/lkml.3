Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab3H2LYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:24:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab3H2LYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:24:35 -0400
Date: Thu, 29 Aug 2013 13:24:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Simon Horman <horms@verge.net.au>
cc: Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v5 0/7] DMA: shdma: switch DT to use OF device ID tables
In-Reply-To: <20130826071725.GJ26682@verge.net.au>
Message-ID: <Pine.LNX.4.64.1308291321260.3786@axis700.grange>
References: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
 <20130825073656.GF8091@intel.com> <20130826071725.GJ26682@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:LZl3bV0v6GMxCGoDzAw4AHYRQZq1vZBn4gSyzyllIJQ
 U6R37QwkIfd24GcMLNz6H8TN+QxTfdgY+CVMqOq2y33X10Aimu
 tLjHR+Kq+FrCPoa4zanIaY8NZAbVIj2nQAT9/J15C2zIGYVeer
 6Go7xhwvtbFsVej9iEQBT52C3h/m/YdJH65iDq4jvWR/4qsUrJ
 aSokqaLSbFzQkjN+hGjiW/x4ALtnzLY8Z2x8GQkwEgc+23X11R
 MUsltxcnqa4jQ8PwDXTm+lAiL44dYL+BlGejR/fUEnR9ClwWvo
 HtXtWot/DJLWHsDCKXacGG+xyOTW8prTKMmQcRX+qBJ08OCyxo
 2mvEI4021wC+sW7bMlognrINo4C/Kcn3BgePzoSEz2dP7NLTOr
 Dj9uWxdjv/MTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Mon, 26 Aug 2013, Simon Horman wrote:

> On Sun, Aug 25, 2013 at 01:06:57PM +0530, Vinod Koul wrote:
> > On Fri, Aug 02, 2013 at 04:50:35PM +0200, Guennadi Liakhovetski wrote:
> > > In this version of shdma Device Tree support I preserved the DT 
> > > configuration approach via OF device ID tables from v4, but now it is only 
> > > used for the DT-mode, the C-version is left untouched. In this series I 
> > > only include one platform: r8a73a4-based APE6EVM, if accepted, others can 
> > > be added easily. I also took care not to include mach/*.h headers in 
> > > driver .c files. To illustrate the use of DT DMA support for MMC DMA on 
> > > APE6EVM a patch from a previously separate patch series "DMA for MMCIF and 
> > > SDHI devices in DT mode"
> > I have applied all the dma patches, the ARM ones fail for me so should possible
> > go thru ARM tree.
> 
> Guennadi, if you need me to queue up any patches please repost them
> once their dependencies are available in a stable branch.

I've just verified, that the current -next has all DMA and MMCIF 
prerequisites for the following my patches:

      ARM: shmobile: armadillo800eva-reference: add MMCIF and SDHI DT nodes
      ARM: shmobile: r8a73a4: add a DMAC platform device and clock for it
      ARM: shmobile: r8a73a4: add a DT node and a clock alias for the DMAC
      ARM: shmobile: ape6evm-reference: enable DMA for the MMC interface
      ARM: shmobile: ape6evm: disable MMCIF Command Completion Signal
      ARM: shmobile: ape6evm: add DMA support to MMCIF
      ARM: shmobile: armadillo800eva: disable MMCIF Command Completion Signal
      ARM: shmobile: kzm9g: disable MMCIF Command Completion Signal
      ARM: shmobile: lager: disable MMCIF Command Completion Signal, add CLK_CTRL2

I can re-send them all to your privetly as an archive, if you like, or you 
can pick their latest versions from an archive or from patchwork.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
