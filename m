Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaBDUZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:25:37 -0500
Received: from mail.eperm.de ([89.247.134.16]:37565 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbaBDUZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:25:35 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de, sandyinchina@gmail.com
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
Date: Tue, 04 Feb 2014 21:25:19 +0100
Message-ID: <2913164.1FI4GNAxTm@tauon>
User-Agent: KMail/4.11.5 (Linux/3.12.7-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140204170823.GF12768@thunk.org>
References: <2039634.jSmQAS6tdi@myon.chronox.de> <20140204170823.GF12768@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 4. Februar 2014, 12:08:23 schrieb Theodore Ts'o:

Hi Theodore,

>
>> [2] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html
>
>which don't really add much to the discussion, but instead just simply
>make an expert question how deep the analysis has gone.  Measuring the
>statistical tests of the entropy pool is a complete waste of time ---
>and in general, using things like "dieharder" don't do anything to
>increase one's confidence (and could decrease one's confidence if it
>makes it appear too much like a snake oil sales document).  Sure,
>passing dieharder is necessary, but it isn't even vaguely close to
>sufficient.
>

I am a bit surprised by this statement because I use statistical test 
only as a necessary baseline. After that, the hard work started on the 
actual noise source by measuring the actual noise coming out of the 
noise sources. All of these tests have nothing to do with the 
statistical tests of dieharder & Co.

That is the sole reason why I looked into testing the timing variations 
on bare metal, independently for each noise source. Also, measuring the 
basic noise on a large array of different CPUs which then show similar 
behaviors are used to help my case.

So, when only looking at the statistical tests, the majority of the work 
is not considered.

Ciao
Stephan
