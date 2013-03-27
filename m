Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3C0Krt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:47:49 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56370 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab3C0Krs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:47:48 -0400
Date: Wed, 27 Mar 2013 19:47:45 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca
Subject: Re: [PATCH] gpio: Renesas R-Car GPIO driver V3
Message-ID: <20130327104744.GD3040@verge.net.au>
References: <20130326002301.10878.32801.sendpatchset@w520>
 <2667057.bEM8NUnrg3@avalon>
 <CANqRtoTtJMELH4R9ekAKdaACeqg2vr3mKCqCFKUcdbsq5dqJPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoTtJMELH4R9ekAKdaACeqg2vr3mKCqCFKUcdbsq5dqJPA@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 11:16:30PM +0900, Magnus Damm wrote:
> Hi Laurent,
> 
> On Tue, Mar 26, 2013 at 10:03 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > Hi Magnus,
> >
> > Thanks for the patch.
> >
> > On Tuesday 26 March 2013 09:23:01 Magnus Damm wrote:
> >> From: Magnus Damm <damm@opensource.se>
> >>
> >> This patch is V3 of a GPIO driver for the R-Car series of
> >> SoCs from Renesas. This driver is designed to be reusable
> >> between multiple SoCs that share the same basic building block,
> >> but so far it has only been used on R-Car H1 (r8a7779).
> 
> >> Signed-off-by: Magnus Damm <damm@opensource.se>
> >
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >
> > I've taken the patch in my tree.
> 
> That's great, thanks!

And in turn I have added it to the pinmux branch of the renesas tree.
