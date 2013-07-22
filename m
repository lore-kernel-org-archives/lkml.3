Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab3GVQR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:17:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab3GVQRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:17:11 -0400
Date: Mon, 22 Jul 2013 09:53:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 04/15] DMA: shdma: make a pointer const
In-Reply-To: <15445605.PE49oOgv4F@avalon>
Message-ID: <Pine.LNX.4.64.1307220941160.7852@axis700.grange>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
 <1374251374-30186-5-git-send-email-g.liakhovetski@gmx.de> <15445605.PE49oOgv4F@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:dwuYwaixEJ0WaxzYLX3T4D9+T+vUNh0d2/npEwzfTh7
 lX87FED/Ym8OxfAK+hqQ52uDIOXNMa+ugbLrankkHbJc0LNBmb
 RPGRC606xBjrEzP1qu20OMS/5gPQg4JrVaKWlP4R1j5fqaem5t
 9qksvg+KIMajkRVDmyydVe9G/CW17j9E8xrPOvWxTikeedRzEO
 +13ZV89g7iFL3WT9dsPTF0Qh3CfmKc3HfTH/3hc6PpWMJtpQvG
 jAKincNG2P0/riLCcMlBSgcf9H8lyBruudSF70LKm1oYxo3hFM
 mHNwbsMyhTQGP1mMsaPgnXXJVd6/MaeH9vjz58taQvKEKUfp5s
 syyIwQxGEjWvfcUrNh6cRAdzfCko8LP+piRNJJCMji+IWiBP6s
 1lpzmStGuUREg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jul 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thanks for the patch.
> 
> On Friday 19 July 2013 18:29:29 Guennadi Liakhovetski wrote:
> > Platform data shouldn't be changed at run-time, so, pointers to it should
> > be const.
> 
> If you move this patch to the beginning of the series you could make the pdata 
> structures const in 02/15 and 03/15.

Are these actually related? I think they can be made const regardless?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
