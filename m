Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaBJVHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:07:00 -0500
Received: from longford.logfs.org ([213.229.74.203]:42790 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaBJVG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:06:59 -0500
Date: Mon, 10 Feb 2014 16:07:44 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
        John Crispin <blogic@openwrt.org>, andrewmcgr@gmail.com,
        Thorsten Glaser <tg@mirbsd.de>, sandyinchina@gmail.com
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
Message-ID: <20140210210744.GA9137@logfs.org>
References: <2039634.jSmQAS6tdi@myon.chronox.de>
 <20140204170823.GF12768@thunk.org>
 <52F13A1C.3040003@zytor.com>
 <20140204192325.GA11831@thunk.org>
 <CAMuHMdV5tLX7L6m4Q+1tMu_LF0bhxErVJuXDcga8VAmGV91dZg@mail.gmail.com>
 <52F15000.2080102@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52F15000.2080102@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 February 2014 12:39:28 -0800, H. Peter Anvin wrote:
> 
> USB and the Ethernet PHY frequently do still have their own crystals,
> for reasons not entirely clear to me.  However, what all of these have
> in common is that they are way out in the periphery.

Storage might be another source.  We have had add_disk_randomness()
forever.  Flash also takes quite variable timings for writes and
erases.  Even if the timings are not random, they certainly change
from block to block and depending on wear.

I am less certain about reads.  But one can run a few experiments and
see how consistent the timings are.

Jörn

--
Linux is more the core point of a concept that surrounds "open source"
which, in turn, is based on a false concept. This concept is that
people actually want to look at source code.
-- Rob Enderle
