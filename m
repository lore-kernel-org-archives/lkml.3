Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaEHSwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:52:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44392 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaEHSwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:52:35 -0400
Message-ID: <536BD280.9070808@cogentembedded.com>
Date: Thu, 08 May 2014 22:52:48 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: shmobile: r8a7740 dtsi: Add Ethernet support
References: <1399494750-31996-1-git-send-email-geert+renesas@glider.be>	<1399494750-31996-2-git-send-email-geert+renesas@glider.be>	<536B7FD3.5090506@cogentembedded.com>	<CAMuHMdVoYnRcOVht0_Bt5_NJA3vZ40svftRXN-xbqHSMHZR5dg@mail.gmail.com>	<536B8340.4010901@cogentembedded.com>	<CAMuHMdUW3ENmykZGNQB8Qo3EVk+7RYzVHa6L-=WsxZZ06mfUTQ@mail.gmail.com>	<536BC445.8080007@cogentembedded.com> <CAMuHMdVR9n8E-LyHn1B0REE4oTVbfJf-9v1Bo70bHCH_=r4-Vw@mail.gmail.com>
In-Reply-To: <CAMuHMdVR9n8E-LyHn1B0REE4oTVbfJf-9v1Bo70bHCH_=r4-Vw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 10:46 PM, Geert Uytterhoeven wrote:

>>>>>>> +               /* clocks = <&mstp3_clks R8A7740_CLK_GETHER>; */

>>>>>>       This property is mandatory, according to the bindings.

>>>>> Indeed, but you cannot put anything there until the platform has CCF, as
>>>>> mstp3_clks doesn't exist yet.

>>>>      Yes, that was the main obstacle to accepting those bindings sooner.
>>>> This patch therefore seems somewhat premature.

>>> My main objective is to provide working Ethernet support for Armadillo
>>> reference now.

>>     Mine was the same (but for BOCK-W board) but DT people didn't give a
>> damn. :-) So there's still no Ethernet support in BOCK-W DT.

> Yes there is: ethernet@18300000.

    That's for an on-board SMSC911x, not for sh_eth.

>>> The DTS already has other nodes without "clocks" properties.

>>     It means not everybody submitting the bindings had the same bad luck as me. :-)

> I think we have to be pragmatic here. The clocks properties will be added to
> the dtsi as soon as we have CCF support.

    I'd agree, so if there's no objections from DT people, I won't object anymore.

> Gr{oetje,eeting}s,
>                          Geert

WBR, Sergei

