Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbaJXCfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:35:00 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:44273 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaJXCe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:34:58 -0400
Date: Fri, 24 Oct 2014 11:34:55 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>, linux-sh@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] clocksource: sh_tmu: Document R-Mobile r8a7740
 binding
Message-ID: <20141024023451.GE7537@verge.net.au>
References: <1413970709-26607-1-git-send-email-geert+renesas@glider.be>
 <1413970709-26607-2-git-send-email-geert+renesas@glider.be>
 <6890235.hnMLlLN6KA@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6890235.hnMLlLN6KA@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 05:59:25PM +0300, Laurent Pinchart wrote:
> Hi Geert,
> 
> Thank you for the patch.
> 
> On Wednesday 22 October 2014 11:38:27 Geert Uytterhoeven wrote:
> > Compared to the r8a7779, the r8a7740 lacks the input capture register,
> > which is not used by the driver (the current driver already handles the
> > r8a7740 in the non-DT case).
> > 
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> 
> > ---
> >  Documentation/devicetree/bindings/timer/renesas,tmu.txt | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/timer/renesas,tmu.txt
> > b/Documentation/devicetree/bindings/timer/renesas,tmu.txt index
> > 7db89fb2544411b5..4ae7910af09ffcb4 100644
> > --- a/Documentation/devicetree/bindings/timer/renesas,tmu.txt
> > +++ b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
> > @@ -1,4 +1,4 @@
> > -* Renesas R-Car Timer Unit (TMU)
> > +* Renesas R-Mobile/R-Car Timer Unit (TMU)
> > 
> >  The TMU is a 32-bit timer/counter with configurable clock inputs and
> >  programmable compare match.
> > @@ -9,6 +9,7 @@ are independent. The TMU hardware supports up to three
> > channels. Required Properties:
> > 
> >    - compatible: must contain one or more of the following:
> > +    - "renesas,tmu-r8a7740" for the r8a7740 TMU
> >      - "renesas,tmu-r8a7779" for the r8a7779 TMU
> >      - "renesas,tmu" for any TMU.
> >        This is a fallback for the above renesas,tmu-* entries
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
