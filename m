Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaGKOXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:23:49 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35769 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaGKOSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:18:30 -0400
Date: Fri, 11 Jul 2014 11:23:08 +0200
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] [RFC] thermal: rcar: Add binding docs for new
 R-Car Gen2 SoCs
Message-ID: <20140711092308.GC22753@verge.net.au>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
 <1404908623-909-13-git-send-email-geert+renesas@glider.be>
 <20140711092112.GQ12420@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711092112.GQ12420@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 11:21:12AM +0200, Simon Horman wrote:
> On Wed, Jul 09, 2014 at 02:23:42PM +0200, Geert Uytterhoeven wrote:
> >   - r8a7792 (R-Car V2H)
> >   - r8a7793 (R-Car M2-N)
> >   - r8a7794 (R-Car E2)
> > 
> > r8a7791 is now called "R-Car M2-W".
> 
> I don't feel strongly about this either way.  But it seems to me that if we
> want to start using "M2-W" then we should make some effort, though not
> necessarily immediately, to update all instances of "M2" that already exist
> in the tree.

Also, as per my comment on tmio-mmc:

	This seems to be in keeping with the approach we ave taken for
	these SoCs for other drivers. And from that point of view it is
	fine by me.  But I wonder how sure are we that the hardware on the
	SoCs will work with this approach.

> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> >  Documentation/devicetree/bindings/thermal/rcar-thermal.txt | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/thermal/rcar-thermal.txt b/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
> > index 0ef00be44b01..43404b197933 100644
> > --- a/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
> > +++ b/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
> > @@ -7,7 +7,10 @@ Required properties:
> >  			    - "renesas,thermal-r8a73a4" (R-Mobile AP6)
> >  			    - "renesas,thermal-r8a7779" (R-Car H1)
> >  			    - "renesas,thermal-r8a7790" (R-Car H2)
> > -			    - "renesas,thermal-r8a7791" (R-Car M2)
> > +			    - "renesas,thermal-r8a7791" (R-Car M2-W)
> > +			    - "renesas,thermal-r8a7792" (R-Car V2H)
> > +			    - "renesas,thermal-r8a7793" (R-Car M2-N)
> > +			    - "renesas,thermal-r8a7794" (R-Car E2)
> >  - reg			: Address range of the thermal registers.
> >  			  The 1st reg will be recognized as common register
> >  			  if it has "interrupts".
> > -- 
> > 1.9.1
> > 
