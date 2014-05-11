Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbaEKIgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 04:36:49 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:52927 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaEKIgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 04:36:21 -0400
Date: Sun, 11 May 2014 10:00:43 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: shmobile: r8a7740 dtsi: Add Ethernet support
Message-ID: <20140511010043.GZ31760@verge.net.au>
References: <1399494750-31996-1-git-send-email-geert+renesas@glider.be>
 <1399494750-31996-2-git-send-email-geert+renesas@glider.be>
 <536B7FD3.5090506@cogentembedded.com>
 <CAMuHMdVoYnRcOVht0_Bt5_NJA3vZ40svftRXN-xbqHSMHZR5dg@mail.gmail.com>
 <536B8340.4010901@cogentembedded.com>
 <CAMuHMdUW3ENmykZGNQB8Qo3EVk+7RYzVHa6L-=WsxZZ06mfUTQ@mail.gmail.com>
 <536BC445.8080007@cogentembedded.com>
 <CAMuHMdVR9n8E-LyHn1B0REE4oTVbfJf-9v1Bo70bHCH_=r4-Vw@mail.gmail.com>
 <536BD280.9070808@cogentembedded.com>
 <CAMuHMdXggzywt8q0DPrBVCyNVPKFXxwk5dKNaqmXHv+wTDRQhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXggzywt8q0DPrBVCyNVPKFXxwk5dKNaqmXHv+wTDRQhw@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 09:01:55PM +0200, Geert Uytterhoeven wrote:
> Hi Sergey,
> 
> On Thu, May 8, 2014 at 8:52 PM, Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com> wrote:
> >>>     Mine was the same (but for BOCK-W board) but DT people didn't give a
> >>> damn. :-) So there's still no Ethernet support in BOCK-W DT.
> >
> >> Yes there is: ethernet@18300000.
> >
> >    That's for an on-board SMSC911x, not for sh_eth.
> 
> Oh, it has two Ethernet ports? Didn't know that.

IIRC only the SMSC911x is exposed on the Bock-W board.

>From my point of view I would be happy to accept support for
the other port if there was some way (for someone to) verify it.
In particular to have the necessary hardware to test it.
I do not believe that I am in a position to do so myself at this time.
