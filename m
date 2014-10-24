Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaJXCPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:15:23 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:41162 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaJXCPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:15:20 -0400
Date: Fri, 24 Oct 2014 11:15:16 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: sh_mtu2: Correct SoC family name
Message-ID: <20141024021513.GD7537@verge.net.au>
References: <1413969978-15946-1-git-send-email-geert+renesas@glider.be>
 <1593823.SBtdMLb0Ra@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593823.SBtdMLb0Ra@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 06:00:19PM +0300, Laurent Pinchart wrote:
> Hi Geert,
> 
> Thank you for the patch.
> 
> On Wednesday 22 October 2014 11:26:18 Geert Uytterhoeven wrote:
> > r7s72100 is a member of the RZ family, not of the R-Car family
> > 
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

My understanding is that mtu2 is an IP block that has been around
inside Renesas for quite some time and has a history of use
on the SH architecture as well as its more recent use on the r7s72100.

So perhaps "Renesas Multi-Function Timer Pulse Unit 2 (MTU2)"
would be (slightly) better.

> > ---
> >  Documentation/devicetree/bindings/timer/renesas,mtu2.txt | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
> > b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt index
> > d9a8d5af1a21270f..55484a77a6ae54d0 100644
> > --- a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
> > +++ b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
> > @@ -1,4 +1,4 @@
> > -* Renesas R-Car Multi-Function Timer Pulse Unit 2 (MTU2)
> > +* Renesas RZ Multi-Function Timer Pulse Unit 2 (MTU2)
> > 
> >  The MTU2 is a multi-purpose, multi-channel timer/counter with configurable
> >  clock inputs and programmable compare match.
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
