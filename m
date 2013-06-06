Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3FFSz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:55:26 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:54375 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3FFSzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:55:25 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Thu, 6 Jun 2013 14:55:15 -0400
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Olof Johansson <olof@lixom.net>, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "luke.leighton" <luke.leighton@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm <debian-arm@lists.debian.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel <debian-kernel@lists.debian.org>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
Message-ID: <20130606185515.GA11182@csclub.uwaterloo.ca>
References: <CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
 <1370469574.18839.33.camel@localhost>
 <CAPweEDxMpeJc-w=Yd7d2OT=UisRBp2rxf-MPMDUCOG3EyJz1GQ@mail.gmail.com>
 <CAKON4OxwyV2f_iTEb5RnP_azc7EsSxPdku_TY5WLWxN7USiY1Q@mail.gmail.com>
 <CAPweEDw1BabE0cmT5fxZ3Z9p9EH508M3Nzcqk2VcO0oz-qYsvg@mail.gmail.com>
 <1370475609.20454.44.camel@localhost>
 <CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
 <CAKON4OxPDpN3BTc9GWP44exDSkAZGJ5OeCpUP37vRnnvxwUnmw@mail.gmail.com>
 <CAOesGMgqxhG45NyCfpHc_0uHS+_Gn-hGZm-+CRvK2EEf1AGTow@mail.gmail.com>
 <20130606172810.GE14209@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606172810.GE14209@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 07:28:10PM +0200, Maxime Ripard wrote:
> I should also add that Allwinner not only talked to us already, but also
> expressed interest in doing actual modern kernel development (like using
> "recently" introduced kernel frameworks, like the clk framework).
> 
> I've received patches from them already for private reviews, they began
> to show up on the kernel mailing lists, they asked to be CCed on the
> patches I send upstream, they're even the one that reached out to me
> when the early support for their chips was released. So, like Olof said,
> they aren't in a vacuum, they are very aware of the mainline kernel and
> speak a decent english.
> 
> So yes, Allwinner has an evil vendor tree (c), with a solution similar yet
> inferior (because not generic enough) to the device tree, but they show
> interest on going down the mainline road.

Well I hope they get there soon, because they sure have some very nice
chip designs at amazing prices.

-- 
Len Sorensen
