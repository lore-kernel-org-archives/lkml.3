Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab3FGXR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:17:56 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35663 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab3FGXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:17:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAF1ZMEets=ea+zpUTUn9Xr-+C+JaKxajK45vK+_mnDJJeoYQpA@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<1370475609.20454.44.camel@localhost>
	<CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
	<1733666.lHUBcfUXq9@flatron>
	<20130606112723.71ddd70c@skate>
	<CAPweEDzW60poOYahm31aW3_A=NvZmyBPPPgM9PzdvuPJnju69A@mail.gmail.com>
	<20130607220853.GR14209@lukather>
	<CAPweEDwFHY_AbBxjspm7BvfdFHsxL5H594cFN4ZVC6QFpu4QGA@mail.gmail.com>
	<CAF1ZMEets=ea+zpUTUn9Xr-+C+JaKxajK45vK+_mnDJJeoYQpA@mail.gmail.com>
Date: Sat, 8 Jun 2013 00:17:54 +0100
Message-ID: <CAPweEDyv=uN8_Ts4miXCGsCrNwYkovLpF_PYF7D1=n2_aZh_wA@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: "Dennis Lan (dlan)" <dennis.yxun@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
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

On Sat, Jun 8, 2013 at 12:09 AM, Dennis Lan (dlan)
<dennis.yxun@gmail.com> wrote:
>
>
> On Saturday, June 8, 2013, luke.leighton wrote:
>>
>> right - too many people contributed to this, input from jon smirl,
>> wookie, maxime, tomasz, henrik, i've made a start here and will
>> continue editing: this is notes for me to put forward an agenda for
>> discussion:
>>
>> http://hands.com/~lkcl/allwinner_linux_proposal.txt
>>
>> i'm setting a rule that each section *has* to have a list of clear
>> benefits, otherwise it'll have to be removed before it goes on to
>> their Directors.
>>
>> so - even if there are any allwinner engineers reading this who would
>> like something put forward please also speak up! :)
>>
>> l.
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>
>
> Hi luke
>      I'm not a allwinner employer :-)$. but pretty much in the same position
> as they are.

 thanks for chipping in.

>      I'd like to add a few comments about the risk of adopting the device
> tree(from allwinner side)
> 1) current using fdt in bootloader(uboot) is not mature, I'm not saying
> about passing the fdt data to kernel.

 mmmm.... fdt.  could you provide some context here?  what is it?
(apart from being a TLA)

>   But the bootloader itself need information from device tree, say boot0/1
> phase (boot device type, DDR initialization...)
>   since fdt is not ready, and SRAM space is very limited ... I'm afraid
> 'fex' may co-exist with device tree.
>   still, they receive benefits if they can adopt device tree, at least
> minimal the kernel side migration effort
>   Generally this info already been pointed out by steppen warren in previous
> email...

 ... which i have to admit i may have missed the significance of or
possibly just missed it entirely.

 what's the main concern you have, here; what's the potential
solution, and what's the benefit of that potential solution, to
allwinner [direct or indirect]?

> 2) device tree may not been understood by third vendors (who previus produce
> shoes or ? :-$),

 :)

>   they are real old 'Fex' scheme user, they like edit the data in windows
> with dos format
>   So, how to fill this gaps, make them happy? Creat another tool to handle
> device tree modification?
>   Then it's another price they have to pay...

 yehh... that kinda looks unavoidable, although it would ultimately
only inconvenience the developers of the proprietary firmware-flashing
tools [livesuite, phoenix] and so would be transparent to the
factories and so on.  i've mentioned the idea of having an in-kernel
translation tool rather than an external (pre-runtime) one, i've yet
to get some feedback on that.

 l.
