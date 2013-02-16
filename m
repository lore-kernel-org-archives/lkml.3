Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3BPGNQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 01:13:16 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:37551 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3BPGNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 01:13:15 -0500
Date: Sat, 16 Feb 2013 15:13:13 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH/RFC] mfd: as3711: add OF support
Message-ID: <20130216061312.GA19142@verge.net.au>
References: <Pine.LNX.4.64.1302151101140.7446@axis700.grange>
 <20130216022630.GA11628@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130216022630.GA11628@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 11:26:30AM +0900, Simon Horman wrote:
> On Fri, Feb 15, 2013 at 11:07:16AM +0100, Guennadi Liakhovetski wrote:
> > Add device-tree bindings to the AS3711 regulator and backlight drivers.
> 
> Hi,
> 
> at this stage I do not expect this code to go through the renesas tree.
> However, in order to provide a basis for work on renesas SoCs I have added
> this patch to the topic/backlight topic branch in the reneas tree on
> kernel.org and merged it into topic/all+next.
> 
> In other words, I am not picking this patch up to merge it or add it to
> linux-next, rather I am storing it for reference.

I have dropped this patch due to the of_device_is_available build error
reported by kbuild and reported in another sub-thread.
