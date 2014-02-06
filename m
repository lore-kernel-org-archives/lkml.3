Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbaBFWUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:20:53 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57579 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbaBFWUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:20:52 -0500
Date: Thu, 6 Feb 2014 14:20:02 -0800
From: Kees Cook <kees@outflux.net>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
        geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Message-ID: <20140206222002.GC23300@outflux.net>
References: <20140202203617.GA9499@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140202203617.GA9499@logfs.org>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jörn,

On Sun, Feb 02, 2014 at 03:36:17PM -0500, Jörn Engel wrote:
> Collects entropy from random behaviour all modern cpus exhibit.  The
> scheduler and slab allocator are instrumented for this purpose.  How
> much randomness can be gathered is clearly hardware-dependent and hard
> to estimate.  Therefore the entropy estimate is zero, but random bits
> still get mixed into the pools.

Have you seen this work from PaX Team?

http://grsecurity.net/pipermail/grsecurity/2012-July/001093.html

See http://grsecurity.net/test/grsecurity-3.0-3.13.1-201402052349.patch
and search for PAX_LATENT_ENTROPY.

-Kees

-- 
Kees Cook                                            @outflux.net
