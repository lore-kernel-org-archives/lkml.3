Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab3HZHRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:17:30 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51542 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3HZHR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:17:29 -0400
Date: Mon, 26 Aug 2013 16:17:25 +0900
From: Simon Horman <horms@verge.net.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v5 0/7] DMA: shdma: switch DT to use OF device ID tables
Message-ID: <20130826071725.GJ26682@verge.net.au>
References: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
 <20130825073656.GF8091@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130825073656.GF8091@intel.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 01:06:57PM +0530, Vinod Koul wrote:
> On Fri, Aug 02, 2013 at 04:50:35PM +0200, Guennadi Liakhovetski wrote:
> > In this version of shdma Device Tree support I preserved the DT 
> > configuration approach via OF device ID tables from v4, but now it is only 
> > used for the DT-mode, the C-version is left untouched. In this series I 
> > only include one platform: r8a73a4-based APE6EVM, if accepted, others can 
> > be added easily. I also took care not to include mach/*.h headers in 
> > driver .c files. To illustrate the use of DT DMA support for MMC DMA on 
> > APE6EVM a patch from a previously separate patch series "DMA for MMCIF and 
> > SDHI devices in DT mode"
> I have applied all the dma patches, the ARM ones fail for me so should possible
> go thru ARM tree.

Guennadi, if you need me to queue up any patches please repost them
once their dependencies are available in a stable branch.
