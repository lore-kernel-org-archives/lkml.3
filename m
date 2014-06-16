Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaFPOiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:38:07 -0400
Received: from one.firstfloor.org ([193.170.194.197]:37518 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbaFPOiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:38:03 -0400
Date: Mon, 16 Jun 2014 16:38:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ian Lance Taylor <iant@golang.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Rich Felker <dalias@libc.org>,
        Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Message-ID: <20140616143801.GJ5714@two.firstfloor.org>
References: <cover.1402769596.git.luto@amacapital.net>
 <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx>
 <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <539DDE9C.3010903@zytor.com>
 <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
 <20140616023604.GI5714@two.firstfloor.org>
 <CAKOQZ8wwKcDAXq0BnHwvL01LQNFeOGwgA9x8kCLWeFaP6USF4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOQZ8wwKcDAXq0BnHwvL01LQNFeOGwgA9x8kCLWeFaP6USF4A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think this issue started when some of the Go developers questioned
> why the kernel needed to provide a very complex interface--parsing an
> ELF shared shared library--for very simple functionality--looking up
> the address of a magic function.  This approach has required special
> support not just in Go, but also in the dynamic linker and gdb, and
> does not work well for statically linked binaries.  The support in gdb
> is perhaps a good idea, but elsewhere it does not make sense.
> 
> So why not provide a simple interface?

What good would it do now that everyone already supports it?

The proposal is 10+ years too late.

-andi
