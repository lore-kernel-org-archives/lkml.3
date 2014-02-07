Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaBGHnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 02:43:53 -0500
Received: from longford.logfs.org ([213.229.74.203]:42745 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaBGHnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 02:43:52 -0500
Date: Fri, 7 Feb 2014 02:44:36 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Kees Cook <kees@outflux.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
        geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Message-ID: <20140207074436.GA11178@logfs.org>
References: <20140202203617.GA9499@logfs.org>
 <20140206222002.GC23300@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140206222002.GC23300@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 February 2014 14:20:02 -0800, Kees Cook wrote:
> On Sun, Feb 02, 2014 at 03:36:17PM -0500, Jörn Engel wrote:
> > Collects entropy from random behaviour all modern cpus exhibit.  The
> > scheduler and slab allocator are instrumented for this purpose.  How
> > much randomness can be gathered is clearly hardware-dependent and hard
> > to estimate.  Therefore the entropy estimate is zero, but random bits
> > still get mixed into the pools.
> 
> Have you seen this work from PaX Team?
> 
> http://grsecurity.net/pipermail/grsecurity/2012-July/001093.html

Interesting.

> See http://grsecurity.net/test/grsecurity-3.0-3.13.1-201402052349.patch
> and search for PAX_LATENT_ENTROPY.

Server gives me an error.  Archive.org doesn't have a copy either,
thanks to robots.txt.

Can you send me a copy via mail?

Jörn

--
Functionality is an asset, but code is a liability.
--Ted Dziuba
