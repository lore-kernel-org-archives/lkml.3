Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3FEXwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:52:43 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36553 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab3FEXwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:52:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAKON4Oz79hUE_ReAqjeynwL6ZWntX2W1uw3YOg0G2AiY7Gjs=g@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
	<51AFA6DD.3000202@wwwdotorg.org>
	<CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
	<1370469574.18839.33.camel@localhost>
	<CAPweEDxMpeJc-w=Yd7d2OT=UisRBp2rxf-MPMDUCOG3EyJz1GQ@mail.gmail.com>
	<CAKON4OxwyV2f_iTEb5RnP_azc7EsSxPdku_TY5WLWxN7USiY1Q@mail.gmail.com>
	<CAPweEDw1BabE0cmT5fxZ3Z9p9EH508M3Nzcqk2VcO0oz-qYsvg@mail.gmail.com>
	<CAKON4Oz79hUE_ReAqjeynwL6ZWntX2W1uw3YOg0G2AiY7Gjs=g@mail.gmail.com>
Date: Thu, 6 Jun 2013 00:52:42 +0100
Message-ID: <CAPweEDyO+Sc1aQ64HBeh1OSzmPNsnwMwEo5kbHSan5vw_YEjXA@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 12:40 AM, jonsmirl@gmail.com <jonsmirl@gmail.com> wrote:

> I have a Cubieboard and I have a pca9532 on my desk. Now I want to
> attach this pca9532 to the Cubieboard so I wire them together on I2C.
>
> How is the Allwinner kernel going to load the driver for the pca9532?
> The mainline pca9532 driver does not understand fex so it can't read
> the necessary initialization data.

 jon: you're immediately outside of the target market for which
allwinner designed and deployed script.fex.

> Luke, you of all people should see what is going on. Take an EOMA
> module based on an A10. Now plug it into ten different hosts with
> widely varying hardware support - like each of the ten hosts has a
> different lm-sensor type chip. Where are the fex drivers for those ten
> different lm-sensor chips going to come from? We already have DT
> support for them.

 that's fantastic, because as you can see, the two systems complement
each other.

> fex is only supported on the small number of peripheral chips
> Allwinner has blessed. Use any chip outside of that set and it isn't
> going to boot.

 eeexactly.  i did say "target market".

 so, we have a clear illustration that neither script.fex nor
devicetree actually help solve the "chip proliferation" problem.  but
that's another story, and getting off-topic.

 what i need is a clear set of proposals, discussed and then the best
one(s) that people can come up with be then summarised so that i can
get them clearly and succinctly across to allwinner, along with the
benefits to allwinner of each of the options.

 time is of the essence, speaking of which i'm pushing things to the
limit including my health so i *really* have to go, i'm going to leave
this up to everyone to discuss, please nominate someone to email me
directly [on a different subject] so that i can read the proposals
summaries should people choose to write any.

 thanks.

l.
