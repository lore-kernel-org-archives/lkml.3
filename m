Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaEKIhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 04:37:10 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:52960 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaEKIgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 04:36:53 -0400
Date: Sun, 11 May 2014 11:25:40 +0900
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: shmobile: r8a7740 dtsi: Add Ethernet support
Message-ID: <20140511022540.GD31760@verge.net.au>
References: <1399494750-31996-1-git-send-email-geert+renesas@glider.be>
 <1399494750-31996-2-git-send-email-geert+renesas@glider.be>
 <536B7FD3.5090506@cogentembedded.com>
 <CAMuHMdVoYnRcOVht0_Bt5_NJA3vZ40svftRXN-xbqHSMHZR5dg@mail.gmail.com>
 <536B8340.4010901@cogentembedded.com>
 <CAMuHMdUW3ENmykZGNQB8Qo3EVk+7RYzVHa6L-=WsxZZ06mfUTQ@mail.gmail.com>
 <536BC445.8080007@cogentembedded.com>
 <CAMuHMdVR9n8E-LyHn1B0REE4oTVbfJf-9v1Bo70bHCH_=r4-Vw@mail.gmail.com>
 <536BD280.9070808@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536BD280.9070808@cogentembedded.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 10:52:48PM +0400, Sergei Shtylyov wrote:
> On 05/08/2014 10:46 PM, Geert Uytterhoeven wrote:
> 
> >>>>>>>+               /* clocks = <&mstp3_clks R8A7740_CLK_GETHER>; */
> 
> >>>>>>      This property is mandatory, according to the bindings.
> 
> >>>>>Indeed, but you cannot put anything there until the platform has CCF, as
> >>>>>mstp3_clks doesn't exist yet.
> 
> >>>>     Yes, that was the main obstacle to accepting those bindings sooner.
> >>>>This patch therefore seems somewhat premature.
> 
> >>>My main objective is to provide working Ethernet support for Armadillo
> >>>reference now.
> 
> >>    Mine was the same (but for BOCK-W board) but DT people didn't give a
> >>damn. :-) So there's still no Ethernet support in BOCK-W DT.
> 
> >Yes there is: ethernet@18300000.
> 
>    That's for an on-board SMSC911x, not for sh_eth.
> 
> >>>The DTS already has other nodes without "clocks" properties.
> 
> >>    It means not everybody submitting the bindings had the same bad luck as me. :-)
> 
> >I think we have to be pragmatic here. The clocks properties will be added to
> >the dtsi as soon as we have CCF support.
> 
>    I'd agree, so if there's no objections from DT people, I won't object anymore.
> 

Hi Laurent, Hi Sergei,

I have queued up this series locally and I plan to push this once I have
done some testing (I am on a plane with neither internet access nor a
consignment of boards).
