Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbaBFWWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:22:00 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:60437 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbaBFWV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:21:58 -0500
MIME-Version: 1.0
In-Reply-To: <20140206222002.GC23300@outflux.net>
References: <20140202203617.GA9499@logfs.org>
	<20140206222002.GC23300@outflux.net>
Date: Thu, 6 Feb 2014 17:21:51 -0500
Message-ID: <CAA93jw6+TS+s4DY_hJ67ZrcMMWm=9=0KjtTNBX52_pXvkOArcQ@mail.gmail.com>
Subject: Re: [PATCH,RFC] random: collect cpu randomness
From: Dave Taht <dave.taht@gmail.com>
To: Kees Cook <kees@outflux.net>
Cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Andrew McGregor <andrewmcgr@gmail.com>,
        Stephan Mueller <smueller@chronox.de>, geert@linux-m68k.org,
        tg@mirbsd.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 5:20 PM, Kees Cook <kees@outflux.net> wrote:
> Hi Jörn,
>
> On Sun, Feb 02, 2014 at 03:36:17PM -0500, Jörn Engel wrote:
>> Collects entropy from random behaviour all modern cpus exhibit.  The
>> scheduler and slab allocator are instrumented for this purpose.  How
>> much randomness can be gathered is clearly hardware-dependent and hard
>> to estimate.  Therefore the entropy estimate is zero, but random bits
>> still get mixed into the pools.
>
> Have you seen this work from PaX Team?
>
> http://grsecurity.net/pipermail/grsecurity/2012-July/001093.html
>
> See http://grsecurity.net/test/grsecurity-3.0-3.13.1-201402052349.patch
> and search for PAX_LATENT_ENTROPY.

The hardware rng world just got easier with the "hashlet".

https://plus.google.com/u/0/107942175615993706558/posts/4iq6W524SxL

Kernel driver wanted...

> -Kees
>
> --
> Kees Cook                                            @outflux.net



-- 
Dave Täht

Fixing bufferbloat with cerowrt: http://www.teklibre.com/cerowrt/subscribe.html
