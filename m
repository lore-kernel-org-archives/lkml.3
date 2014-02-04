Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935247AbaBDVs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:48:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48977 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932635AbaBDVsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:48:25 -0500
Message-ID: <52F16003.60306@zytor.com>
Date: Tue, 04 Feb 2014 13:47:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, Dave Taht <dave.taht@gmail.com>,
        John Crispin <blogic@openwrt.org>,
        Andrew McGregor <andrewmcgr@gmail.com>, Thorsten Glaser <tg@mirbsd.de>,
        sandyinchina@gmail.com
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
References: <2039634.jSmQAS6tdi@myon.chronox.de>	<20140204170823.GF12768@thunk.org>	<52F13A1C.3040003@zytor.com>	<20140204192325.GA11831@thunk.org>	<CAMuHMdV5tLX7L6m4Q+1tMu_LF0bhxErVJuXDcga8VAmGV91dZg@mail.gmail.com>	<52F15000.2080102@zytor.com> <CAMuHMdXdYBB9AfdE4qb846SmkO_pqEqtrUsFL=d09tAqgmkXTQ@mail.gmail.com>
In-Reply-To: <CAMuHMdXdYBB9AfdE4qb846SmkO_pqEqtrUsFL=d09tAqgmkXTQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 01:46 PM, Geert Uytterhoeven wrote:
> 
> Because they're fixed frequency, and used for communication with other
> devices, so accuracy matters?
> 
> Other clocks can be tuned for performance or power reasons, but clocks
> for communication must be fixed and stable. You can run e.g. your CPU
> or memory a bit slower or faster, but not your Ethernet.
> 

But modern frequency synthesizers can do that easily.

	-hpa


