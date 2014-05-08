Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaEHSqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:46:37 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48776 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaEHSqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:46:34 -0400
MIME-Version: 1.0
In-Reply-To: <536BC445.8080007@cogentembedded.com>
References: <1399494750-31996-1-git-send-email-geert+renesas@glider.be>
	<1399494750-31996-2-git-send-email-geert+renesas@glider.be>
	<536B7FD3.5090506@cogentembedded.com>
	<CAMuHMdVoYnRcOVht0_Bt5_NJA3vZ40svftRXN-xbqHSMHZR5dg@mail.gmail.com>
	<536B8340.4010901@cogentembedded.com>
	<CAMuHMdUW3ENmykZGNQB8Qo3EVk+7RYzVHa6L-=WsxZZ06mfUTQ@mail.gmail.com>
	<536BC445.8080007@cogentembedded.com>
Date: Thu, 8 May 2014 20:46:34 +0200
X-Google-Sender-Auth: 82ByOs_HCivwACmkdu7ZrFqUJCA
Message-ID: <CAMuHMdVR9n8E-LyHn1B0REE4oTVbfJf-9v1Bo70bHCH_=r4-Vw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: shmobile: r8a7740 dtsi: Add Ethernet support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Thu, May 8, 2014 at 7:52 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>>>>>> +               /* clocks = <&mstp3_clks R8A7740_CLK_GETHER>; */
>
>>>>>      This property is mandatory, according to the bindings.
>
>>>> Indeed, but you cannot put anything there until the platform has CCF, as
>>>> mstp3_clks doesn't exist yet.
>
>>>     Yes, that was the main obstacle to accepting those bindings sooner.
>>> This patch therefore seems somewhat premature.
>
>> My main objective is to provide working Ethernet support for Armadillo
>> reference now.
>
>    Mine was the same (but for BOCK-W board) but DT people didn't give a
> damn. :-) So there's still no Ethernet support in BOCK-W DT.

Yes there is: ethernet@18300000.

>> The DTS already has other nodes without "clocks" properties.
>
>    It means not everybody submitting the bindings had the same bad luck as me. :-)

I think we have to be pragmatic here. The clocks properties will be added to
the dtsi as soon as we have CCF support.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
