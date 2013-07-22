Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3GVXgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:36:17 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:42224 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3GVXgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:36:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 04/15] DMA: shdma: make a pointer const
Date: Tue, 23 Jul 2013 01:37:06 +0200
Message-ID: <2697597.tfSXoJkJMv@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1307220941160.7852@axis700.grange>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de> <15445605.PE49oOgv4F@avalon> <Pine.LNX.4.64.1307220941160.7852@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Monday 22 July 2013 09:53:51 Guennadi Liakhovetski wrote:
> On Sun, 21 Jul 2013, Laurent Pinchart wrote:
> > On Friday 19 July 2013 18:29:29 Guennadi Liakhovetski wrote:
> > > Platform data shouldn't be changed at run-time, so, pointers to it
> > > should be const.
> > 
> > If you move this patch to the beginning of the series you could make the
> > pdata structures const in 02/15 and 03/15.
> 
> Are these actually related? I think they can be made const regardless?

Right, the compiler will probably not complain, as the platform data pointer 
introduced by patches 02 and 03 are cast to an unsigned long.

-- 
Regards,

Laurent Pinchart

