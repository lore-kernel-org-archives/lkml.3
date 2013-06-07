Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab3FGSpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:45:10 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:61201 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab3FGSpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:45:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMgqxhG45NyCfpHc_0uHS+_Gn-hGZm-+CRvK2EEf1AGTow@mail.gmail.com>
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
	<CAOesGMgqxhG45NyCfpHc_0uHS+_Gn-hGZm-+CRvK2EEf1AGTow@mail.gmail.com>
Date: Fri, 7 Jun 2013 19:45:07 +0100
Message-ID: <CAPweEDwU+RzTCGb20uh7jxAzjbrX_yHVa4sy_ATr7MWpBb4WcQ@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm <debian-arm@lists.debian.org>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 5:00 PM, Olof Johansson <olof@lixom.net> wrote:
> On Thu, Jun 6, 2013 at 8:13 AM, jonsmirl@gmail.com <jonsmirl@gmail.com> wrote:
>> On Wed, Jun 5, 2013 at 7:54 PM, luke.leighton <luke.leighton@gmail.com> wrote:
>>>  augh.  ok.  solutions.  what are the solutions here?
>>
>> Luke if you really want to fix this a good solution is to have
>> Allwinner join Linaro and provide an engineer to the Linaro effort.
>> That engineer will get educated on the right way to do kernel
>> development and he can pass that knowledge back to Allwinner each day
>> as he learns it.
>
> There's no need for anybody to join Linaro to contribute upstream.
> That's a crazy notion.

 indeed.  this is a company that produced a 70-page "datasheet" when
freescale produced 4,500 for the iMX6.  i passed on that link and i
believe it'll be an eye-opener to their engineers: education is what's
key here, and you don't need to pay vast sums to do it.

 although the quantities they're selling are just ennorrrmous,
allowing them to undercut absolutely everybody because they can pay
absolute best rates to the Fab Houses (TSMC etc.) their profit margins
are going to be exceptionally slim.

 so we cannot count on them having a spare $1m per year to give to
linaro, so yes, i tend to agree with what you're implying, olof, that
allwinner should be encouraged to participate more in upstream
contribution.

 so.

 could someone please describe to me what they should do, here?  whom
should they best contact, what lists, what's the procedures, where's
the best-working-practices, where are the foundations with which they
can participate that have the formal procedures for proposals [similar
to python's PEP and debian's DEP].  that last was a not-very-subtle
hint, btw.

 and... please... i've yet to receive *any* answers to the question
"and what are the benefits that they would get by doing so"!!

> Listen, Allwinner isn't working in a vacuum, believe it or not. I've
> talked to them, so has Arnd and other people working on ARM, including
> Maxime Ripard, who's been reimplementing upstream support for their
> platform.

 great.

> Everybody is interested in the right things happening, it's
> just a matter of figuring out how to do it. The right people are
> already talking.

 .... but the Directors of Allwinner aren't been kept in the loop,
here: that's my job, to get them up-to-speed.

>> the cost of joining. The net result will likely be a reduction in the
>> amount they need to spend on in-house development since they will
>> learn how to better leverage other developer's work.

 but you forget one thing: they only need *ever* produce *one*
board/kernel.  they have a registered board type, it covers *all*
products and i mean *all* products.  i don't mean that in the "usual"
way where most companies re-use a single machine type for multiple
devices and irritate the crap out of linux kernel developers when the
GPL source finally "leaks", i mean "thanks to script.fex they
LITERALLY only ever compile one binary and then customise script.fex
on a per-customer basis".

 so the usual lessons really do not apply, here.

 the only one i spotted was that they rather foolishly made duplicates
of sun5i_usb and renamed all the files (s/SUN5I/SUN7I/g) to make
sun7i_usb, then started editing.  one of the developers created a
buffer overflow, which corrupted internal memory, and there are signs
that he then started experimenting switching off DMA trying to fix
various problems.

 if he'd done a proper job #ifdef CONFIG_SUN7I_USB #ifdef
CONFIG_SUN5I_USB in the same source code etc etc. and tested on
known-good [older] hardware he would have noticed that the
modifications failed on previously-known-good hardware and would have
spotted the buffer overflow error much sooner.

 that _is_ something i will be bringing to the Director's attention,
that the "strategy" of cut-paste-itis has detrimental effects.

ok.  so.  apologies, bit of a digression there.

 question for you olof [and others of course]: you've clearly listed
some benefits, which i'm very very grateful for.  in light of what i
describe above [the "we only need ever write one kernel" strategy
which is serving Allwinner really really well apart from the
code-duplication mistake], do the benefits you list *still* apply, and
if so, could you please elaborate for me, assume i'm thick or
something [or at least not a programmer, which i am unfortunately so
might miss something]

l.
