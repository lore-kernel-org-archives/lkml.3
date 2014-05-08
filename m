Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaEHTB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:01:58 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:38263 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaEHTBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <536BD280.9070808@cogentembedded.com>
References: <1399494750-31996-1-git-send-email-geert+renesas@glider.be>
	<1399494750-31996-2-git-send-email-geert+renesas@glider.be>
	<536B7FD3.5090506@cogentembedded.com>
	<CAMuHMdVoYnRcOVht0_Bt5_NJA3vZ40svftRXN-xbqHSMHZR5dg@mail.gmail.com>
	<536B8340.4010901@cogentembedded.com>
	<CAMuHMdUW3ENmykZGNQB8Qo3EVk+7RYzVHa6L-=WsxZZ06mfUTQ@mail.gmail.com>
	<536BC445.8080007@cogentembedded.com>
	<CAMuHMdVR9n8E-LyHn1B0REE4oTVbfJf-9v1Bo70bHCH_=r4-Vw@mail.gmail.com>
	<536BD280.9070808@cogentembedded.com>
Date: Thu, 8 May 2014 21:01:55 +0200
X-Google-Sender-Auth: MQsibnM8gnxkCKFPq4YZXy6gbhQ
Message-ID: <CAMuHMdXggzywt8q0DPrBVCyNVPKFXxwk5dKNaqmXHv+wTDRQhw@mail.gmail.com>
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

Hi Sergey,

On Thu, May 8, 2014 at 8:52 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>>>     Mine was the same (but for BOCK-W board) but DT people didn't give a
>>> damn. :-) So there's still no Ethernet support in BOCK-W DT.
>
>> Yes there is: ethernet@18300000.
>
>    That's for an on-board SMSC911x, not for sh_eth.

Oh, it has two Ethernet ports? Didn't know that.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
