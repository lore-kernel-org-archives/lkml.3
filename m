Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3FGSvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:51:46 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35102 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab3FGSuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:50:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130606172810.GE14209@lukather>
References: <51AFA6DD.3000202@wwwdotorg.org>
	<CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
	<1370469574.18839.33.camel@localhost>
	<CAPweEDxMpeJc-w=Yd7d2OT=UisRBp2rxf-MPMDUCOG3EyJz1GQ@mail.gmail.com>
	<CAKON4OxwyV2f_iTEb5RnP_azc7EsSxPdku_TY5WLWxN7USiY1Q@mail.gmail.com>
	<CAPweEDw1BabE0cmT5fxZ3Z9p9EH508M3Nzcqk2VcO0oz-qYsvg@mail.gmail.com>
	<1370475609.20454.44.camel@localhost>
	<CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
	<CAKON4OxPDpN3BTc9GWP44exDSkAZGJ5OeCpUP37vRnnvxwUnmw@mail.gmail.com>
	<CAOesGMgqxhG45NyCfpHc_0uHS+_Gn-hGZm-+CRvK2EEf1AGTow@mail.gmail.com>
	<20130606172810.GE14209@lukather>
Date: Fri, 7 Jun 2013 19:50:00 +0100
Message-ID: <CAPweEDyg11k++gunqVQkbwi_-MvhexAX6Z_kjM=3rFBi7qNnzg@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Olof Johansson <olof@lixom.net>, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm <debian-arm@lists.debian.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 6:28 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> I should also add that Allwinner not only talked to us already,

 oo!  great!  can you please [privately, not publicly] let me know who
that is, so i can let the Directors know, so that they can follow up?

> but also
> expressed interest in doing actual modern kernel development (like using
> "recently" introduced kernel frameworks, like the clk framework).

 awesome.

> I've received patches from them already for private reviews, they began
> to show up on the kernel mailing lists, they asked to be CCed on the
> patches I send upstream, they're even the one that reached out to me
> when the early support for their chips was released. So, like Olof said,
> they aren't in a vacuum, they are very aware of the mainline kernel and
> speak a decent english.

 good!  next thing you know they'll be writing comments in english too [*1]

> So yes, Allwinner has an evil vendor tree (c), with a solution similar yet
> inferior (because not generic enough) to the device tree, but they show
> interest on going down the mainline road.

 yes.  i'm coming at this from the other end, via the top management,
so that this is properly coordinated.

 so.  reminder.  and question.  what needs to be done, and what are
the benefits?

 l.


[*1] http://git.rhombus-tech.net/?p=linux.git;a=blob;f=drivers/usb/sun7i_usb/manager/usb_manager.c;h=3775c83134efee9694789b68e85010ebc0d9938b;hb=refs/heads/lkcl-3.3-a20#l274
