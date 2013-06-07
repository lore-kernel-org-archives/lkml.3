Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab3FGTI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:08:26 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50154 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3FGTIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:08:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130607185724.GZ14125@stoneboat.aleph1.co.uk>
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
	<20130607185724.GZ14125@stoneboat.aleph1.co.uk>
Date: Fri, 7 Jun 2013 20:08:24 +0100
Message-ID: <CAPweEDw3_M_5e_B2HueCNcfXjO9_4_oiCJuEfTERetyoOx=+vw@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "luke.leighton" <luke.leighton@gmail.com>,
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

On Fri, Jun 7, 2013 at 7:57 PM, Wookey <wookey@wookware.org> wrote:
> OK, this sounds good. Could you say who the allwinner engineers are?

 [cross-over: i asked him if he'd be happy to let me know privately,
so i have at least some context when speaking to the Directors]

> I
> guess it's quite a large organisation, so if Crazy Luke can say 'the
> work of mainline integration using device-tree is already being done
> by $these $people, please talk to them to help move it along', that
> might help get everyone on the same page.

 .... *mull*, *mull*... yes exactly!

> If it's like many large organisations, some bits of it will 'get it'
> and see why, in the long term, mainline integration is worthwhile, but
> other bits will look at what they have now and their android focus,
> and decide it's easier to keep doing what they are doing.
>
> There is a lot of hardware using these socs, and I'd love to be able
> to use that with mainstream stuff, rather than random vendor piles,
> and specific android kernels, so anything we can do to help make that
> happen is good.
>
>> So yes, Allwinner has an evil vendor tree (c), with a solution similar yet
>> inferior (because not generic enough) to the device tree, but they show
>> interest on going down the mainline road.
>
> So, luke: mainline is not going to support fex directly, whatever you
> or allwinner do. The advantages to allwinner of working with mainline
> are:
> 1) Ability to use whatever (kernel supported) hardware they like with
> new designs, with no driver work
> 2) Ability to use latest kernels and thus whatever shiny goodies those
> include
> 3) No need to do fex-ready drivers for new hardware
> 4) No need to keep backporting new kernels to add fex integration
> forevermore

 hooraaaaay - thank you wookey, this is exactly what i need.
cut/paste, straight into the report.

> If they want to keep existing tools and fex workflow then a fex<->DT
> translation tool will be needed.

 in-kernel or external tool?

> (It's not clear to me to what degree
> DT can simply be used instead directly)

 TBD.  input here, anyone?
