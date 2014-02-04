Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbaBDQyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:54:14 -0500
Received: from mail.eperm.de ([89.247.134.16]:51705 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbaBDQyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:54:01 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
        John Crispin <blogic@openwrt.org>, andrewmcgr@gmail.com,
        Thorsten Glaser <tg@mirbsd.de>, sandyinchina@gmail.com
Subject: Re: [PATCH 2/5] CPU Jitter RNG: Enable compilation
Date: Tue, 04 Feb 2014 17:53:39 +0100
Message-ID: <4270486.pLbfl66a7r@tauon>
User-Agent: KMail/4.11.5 (Linux/3.12.7-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140204163957.GA13928@order.stressinduktion.org>
References: <2039634.jSmQAS6tdi@myon.chronox.de> <3579180.ti4z33qfDe@tauon> <20140204163957.GA13928@order.stressinduktion.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 4. Februar 2014, 17:39:57 schrieb Hannes Frederic Sowa:

Hi Hannes,

>On Tue, Feb 04, 2014 at 05:19:52PM +0100, Stephan Mueller wrote:
>> Also, I consider the execution speed of the entropy collection is not
>> really an issue because the RNG delivers random numbers at a
>> comparatively high rate. Any other noise source feeding into random.c
>> delivers data with far less speed.
>
>Compiling the kernel with -O0 could add some other problems, like

I thought with the given flag, I only compile the respective C file 
without optimizations, but not the entire kernel. Am I wrong here?

>e.g. not doing enough constant folding which could result in linking
>errors. I guess it is not a problem currently though, but some of the
>compile time checks depend on this (compiletime_assert and such).

How do you think that my folding code can cause linking errors?
>
>Have you looked into adding compiler barriers into relevant places in
>the loops to stop the compiler from optimizing and spill out the
>values from the registers to their memory locations?

I did not look into that one, let me have a look.
>
>Greetings,
>
>  Hannes


Ciao
Stephan
