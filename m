Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3FFQAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:00:04 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:46693 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3FFQAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:00:01 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CAKON4OxPDpN3BTc9GWP44exDSkAZGJ5OeCpUP37vRnnvxwUnmw@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
	<51AFA6DD.3000202@wwwdotorg.org>
	<CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
	<1370469574.18839.33.camel@localhost>
	<CAPweEDxMpeJc-w=Yd7d2OT=UisRBp2rxf-MPMDUCOG3EyJz1GQ@mail.gmail.com>
	<CAKON4OxwyV2f_iTEb5RnP_azc7EsSxPdku_TY5WLWxN7USiY1Q@mail.gmail.com>
	<CAPweEDw1BabE0cmT5fxZ3Z9p9EH508M3Nzcqk2VcO0oz-qYsvg@mail.gmail.com>
	<1370475609.20454.44.camel@localhost>
	<CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
	<CAKON4OxPDpN3BTc9GWP44exDSkAZGJ5OeCpUP37vRnnvxwUnmw@mail.gmail.com>
Date: Thu, 6 Jun 2013 09:00:00 -0700
Message-ID: <CAOesGMgqxhG45NyCfpHc_0uHS+_Gn-hGZm-+CRvK2EEf1AGTow@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: Olof Johansson <olof@lixom.net>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: "luke.leighton" <luke.leighton@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm <debian-arm@lists.debian.org>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 8:13 AM, jonsmirl@gmail.com <jonsmirl@gmail.com> wrote:
> On Wed, Jun 5, 2013 at 7:54 PM, luke.leighton <luke.leighton@gmail.com> wrote:
>>  augh.  ok.  solutions.  what are the solutions here?
>
> Luke if you really want to fix this a good solution is to have
> Allwinner join Linaro and provide an engineer to the Linaro effort.
> That engineer will get educated on the right way to do kernel
> development and he can pass that knowledge back to Allwinner each day
> as he learns it.

There's no need for anybody to join Linaro to contribute upstream.
That's a crazy notion.

Listen, Allwinner isn't working in a vacuum, believe it or not. I've
talked to them, so has Arnd and other people working on ARM, including
Maxime Ripard, who's been reimplementing upstream support for their
platform. Everybody is interested in the right things happening, it's
just a matter of figuring out how to do it. The right people are
already talking.

> Allwinner has expressed interest in the past in joining Linaro but the
> price was too high. I believe there are cheaper options now for
> joining. The benefits Allwinner receives from joining will far exceed
> the cost of joining. The net result will likely be a reduction in the
> amount they need to spend on in-house development since they will
> learn how to better leverage other developer's work.

Uh, you're listing the benefits of doing upstream work, not of joining Linaro.


-Olof
