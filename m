Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3H1HTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 03:19:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50912 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3H1HTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 03:19:04 -0400
Date: Wed, 28 Aug 2013 09:18:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] DMA: shdma: fix a bad merge - remove free_irq()
In-Reply-To: <20130828054917.GI2748@intel.com>
Message-ID: <Pine.LNX.4.64.1308280841530.22743@axis700.grange>
References: <Pine.LNX.4.64.1308261426320.1767@axis700.grange>
 <20130826135308.GP2748@intel.com> <Pine.LNX.4.64.1308271028500.11515@axis700.grange>
 <20130827090112.GT2748@intel.com> <Pine.LNX.4.64.1308271625560.11515@axis700.grange>
 <20130828054917.GI2748@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:MeaXpW5ltOuaJ8UoJFvXJIFeNcwSy4gQ/h/PQuveYei
 i+UwGNxLnKJ7AA7iDaua8D87l1+WyQG3ZJe2tRTW5EFYzaA/oR
 Q62j9UOCxgl0SOrpdEUHYY2n2nHGuInIRVKG6pUBWbT4V+u9rO
 OXFak+LK4QrMxW+W07AN2zE82moMY++XYvQowIA5V1UYPnvgKS
 mesPywrAtKxh8zxkgGFuTb2lEJDTQNxQh4ohBeSBF4mMeshpPQ
 /fDE+a94at8pTLIlczTSI9XAev0IFuq+mlX5hpboFMLrDy+xxG
 rYN+v/z9fPoURkqqb5QSbLcJ4xZ91WDyMXgzJq21ZZ0cFqMaJs
 KSRSllmVY4g7J2DFJzpaKgnyKDvOJJRxxdiwMca7PZZRj9R80G
 iHSm04Bvd03Hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Wed, 28 Aug 2013, Vinod Koul wrote:

> On Tue, Aug 27, 2013 at 04:46:51PM +0200, Guennadi Liakhovetski wrote:
> > Ok, to me it looks like you did fix some patches in the topic/sh branch, 
> > but:
> > 
> > patch "DMA: shdma: move two macros to a header" is missing
> > patch "dma: use dev_get_platdata()" is missing (but ok, it's common for 
> > drivers/dma, not sh-specific)
> I havent applied that yet, its in my queue..
> > patch "shdma: fixup sh_dmae_get_partial() calculation error" is missing
> Can you resend these two...?

Ok, sorry, there was some confusion: yesterday no -next tree was 
available, so, I had to use the ARM sh-mobile tree with your slave-dma 
"next" branch merged on top. So, of the 3 above patches

1. "DMA: shdma: move two macros to a header"
2. "dma: use dev_get_platdata()"
3. "shdma: fixup sh_dmae_get_partial() calculation error"

#2 and #3 are already in "next" as 3c4d927 and d4adcc0 respectively, so, 
no need to resend. #1 is available here 
https://patchwork.kernel.org/patch/2831934/

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
