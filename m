Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaBCNGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:06:22 -0500
Received: from mail.eperm.de ([89.247.134.16]:33884 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaBCNGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:06:21 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Date: Mon, 03 Feb 2014 14:06:06 +0100
Message-ID: <1986906.jste579uFo@tauon>
User-Agent: KMail/4.11.5 (Linux/3.12.7-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140203013922.GB6264@thunk.org>
References: <20140202203617.GA9499@logfs.org> <16782692.5vMS7Bhbvf@myon.chronox.de> <20140203013922.GB6264@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 2. Februar 2014, 20:39:22 schrieb Theodore Ts'o:

Hi Theodore,

>On Sun, Feb 02, 2014 at 10:25:31PM +0100, Stephan Mueller wrote:
>> Second, when I offered my initial patch which independently collects
>> some entropy on the CPU execution timing, I got shot down with one
>> concern raised by Ted, and that was about whether a user can
>> influence the entropy collection process.
>
>Um, that wasn't my concern.  After all, when we sample keyboard timing
>while trying to generate a GPG key, of course the user can and does
>influence the entropy collection process.

Thank you for clarifying and sorry that I misunderstood you.

>I really like Jörn's tests doing repeated boot testing and observing
>on a SMP system, the slab allocation pattern is quite deterministic.
>So even though the numbers might *look* random, an attacker with deep
>knowledge of how the kernel was compiled and what memory allocations
>get done during the boot sequence would be able to quite successfuly
>measure it.
>
>I'm guessing that indeed, on a 4-CPU KVM system, what you're measuring

Please let me point out that I am not testing on KVM, but on Linux 
running natively on the hardware. All major CPUs were tested. Even tests 
are executed on bare metal, i.e. without any OS and interrupts disabled. 
But I will explain that in a separate email and do not want to hijack 
this thread.

Ciao
Stephan
