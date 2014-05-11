Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaEKNsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 09:48:43 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:63074 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaEKNsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 09:48:39 -0400
Message-ID: <536F7FB6.5090508@cogentembedded.com>
Date: Sun, 11 May 2014 17:48:38 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: shmobile: r8a7740 dtsi: Add Ethernet support
References: <1399494750-31996-1-git-send-email-geert+renesas@glider.be> <1399494750-31996-2-git-send-email-geert+renesas@glider.be> <536B7FD3.5090506@cogentembedded.com> <CAMuHMdVoYnRcOVht0_Bt5_NJA3vZ40svftRXN-xbqHSMHZR5dg@mail.gmail.com> <536B8340.4010901@cogentembedded.com> <CAMuHMdUW3ENmykZGNQB8Qo3EVk+7RYzVHa6L-=WsxZZ06mfUTQ@mail.gmail.com> <536BC445.8080007@cogentembedded.com> <CAMuHMdVR9n8E-LyHn1B0REE4oTVbfJf-9v1Bo70bHCH_=r4-Vw@mail.gmail.com> <536BD280.9070808@cogentembedded.com> <CAMuHMdXggzywt8q0DPrBVCyNVPKFXxwk5dKNaqmXHv+wTDRQhw@mail.gmail.com> <20140511010043.GZ31760@verge.net.au>
In-Reply-To: <20140511010043.GZ31760@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/11/2014 05:00 AM, Simon Horman wrote:

>>>>>      Mine was the same (but for BOCK-W board) but DT people didn't give a
>>>>> damn. :-) So there's still no Ethernet support in BOCK-W DT.

>>>> Yes there is: ethernet@18300000.

>>>     That's for an on-board SMSC911x, not for sh_eth.

>> Oh, it has two Ethernet ports? Didn't know that.

> IIRC only the SMSC911x is exposed on the Bock-W board.

    Not really. You're probably mixing it with Marzen.

> From my point of view I would be happy to accept support for
> the other port if there was some way (for someone to) verify it.

    There is, and you have accepted such support in the legacy board file.
I had to postpone Ether DT support to the time when CCF support is available, 
though I have posted corresponding patches without the "clocks" property already.

WBR, Sergei

