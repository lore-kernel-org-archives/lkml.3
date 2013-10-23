Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3JWWy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 18:54:58 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:18230 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3JWWy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 18:54:57 -0400
X-AuditID: cbfec372-b7fe76d000003347-bc-526853be6b6a
Date: Wed, 23 Oct 2013 23:54:48 +0100
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Don't send to devicetree list for
 "arch/*/boot/dts"
Message-id: <20131023235448.4de21b8d.m.chehab@samsung.com>
In-reply-to: <52680380.7020204@gmail.com>
References: <1382534520-15688-1-git-send-email-dianders@chromium.org>
 <52680380.7020204@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/hYN19wRlBBjs/qVjMWb+GzWLWtSCL
	+UfOsVqcXXaQzeLAnx2MFs2L17NZzL7/mMXi8q45bBaHVxxgsvj+7RubA5fHgs9X2D2O3J7B
	7DG74SKLx85Zd9k97lzbw+ZxYsZvFo/9c9ewe3xZdY3Z4/MmuQDOKC6blNSczLLUIn27BK6M
	W9deMBdcE65Y+W8JawPjDf4uRg4OCQETia5raV2MnECmmMSFe+vZuhi5OIQEljBKPJh7mAnC
	aWSS6NrzgAmkikVAVaJz/Vswm03ASOJVYwsriC0ioC7xbflxsG5mgftMEluvnmcB2SAsEC4x
	Yb8GSA2vgJXErXl7weo5BTQler6eZQIpERJIkbj6LADiHieJ3QekIKoFJX5MvscCYjMDTZ80
	bxEzhK0t8eTdBdYJjAKzkJTNQlI2C0nZAkbmVYyipcXJBcVJ6bmGesWJucWleel6yfm5mxgh
	UVK0g/HZBqtDjAIcjEo8vBof0oOEWBPLiitzDzFKcDArifBe8M4IEuJNSaysSi3Kjy8qzUkt
	PsTIxMEp1cB4gEfEcbcN29VjrwVWnzo+J3nGq0mrZ7rdXPO/j2ObiPBlRXWfb6cip3eUca1n
	WbS+dn7Jfc8t+tmr/y73ybAVKN/ioHPp/dNPwVXtJsEaMk9FjL6FhPZ4O/M/Daz+8VHY+mb2
	s5YTnx5Jan/dtIlD8TXrNpftLFlbtm9j2D/5gLMaU9z2BE1LJZbijERDLeai4kQALL/bWnAC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 23 Oct 2013 12:12:32 -0500
Rob Herring <robherring2@gmail.com> escreveu:

> On 10/23/2013 08:22 AM, Doug Anderson wrote:
> > As discussed in the ARM kernel summit, people on the devicetree list
> > would no longer like to receive emails about all dts changes.  Remove
> > from MAINTAINERS.
> 
> We need to make sure platform maintainers are copied though. That may be
> hard since we don't have standard layout/naming of dts files.
> 
> We might also want to drop these:
> K:      of_get_property
> K:      of_match_table
> 
> They are at least on the wrong maintainer list now as they should be
> associated with the binding maintainers and not DT core code if we do
> keep them.
> 
> Also based on the discussion, we need to add
> Documentation/devicetree/bindings/* to appropriate subsystem
> maintainers, but that should probably wait until after Friday at least.

/me is confused. What's the procedure for the DT patches for the devices
supported by the subsystem I maintain, e. g. patches for
/drivers/media/platform? 

Should I just apply them, if I think that it is needed by the hardware? 
Are there any criteria to be followed? If so, what criteria?

/me hopes that all those questions will be discussed/answered at KS on
Friday's discussions ;)

In any case, my suggestion is that this patch should be a way more verbose,
and should come together with a patch adding something at Documentation
(SubmittingPatches, or maybe SubmitingDTPatches) in order to be sure that
both developers and subsystem maintainers will do the right thing.

Thanks,
Mauro
> 
> Rob
> 
> > 
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> > ---
> >  MAINTAINERS | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index ebaf8bd..0166e8e 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5987,7 +5987,6 @@ OMAP DEVICE TREE SUPPORT
> >  M:	Benoît Cousson <bcousson@baylibre.com>
> >  M:	Tony Lindgren <tony@atomide.com>
> >  L:	linux-omap@vger.kernel.org
> > -L:	devicetree@vger.kernel.org
> >  S:	Maintained
> >  F:	arch/arm/boot/dts/*omap*
> >  F:	arch/arm/boot/dts/*am3*
> > @@ -6167,7 +6166,6 @@ M:	Ian Campbell <ijc+devicetree@hellion.org.uk>
> >  L:	devicetree@vger.kernel.org
> >  S:	Maintained
> >  F:	Documentation/devicetree/
> > -F:	arch/*/boot/dts/
> >  F:	include/dt-bindings/
> >  
> >  OPENRISC ARCHITECTURE
> > 
> 


-- 

Cheers,
Mauro
