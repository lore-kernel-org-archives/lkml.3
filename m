Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab3KFLt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:49:58 -0500
Received: from mail.eperm.de ([89.247.134.16]:43434 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab3KFLtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:49:55 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Pavel Machek <pavel@ucw.cz>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Wed, 06 Nov 2013 12:49:45 +0100
Message-ID: <4306229.ErfOL470s2@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1762585.cs6mj77ady@tauon>
References: <2579337.FPgJGgHYdz@tauon> <20131103124135.GB32091@thunk.org> <1762585.cs6mj77ady@tauon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 5. November 2013, 13:20:57 schrieb Stephan Mueller:

Hi Ted,

>Am Sonntag, 3. November 2013, 07:41:35 schrieb Theodore Ts'o:
>
>Hi Theodore,
>
>>On Sun, Nov 03, 2013 at 08:20:34AM +0100, Stephan Mueller wrote:
>>
>>Sandy Harris pointed out a very good paper that I would definitely
>>recommend that people read:
>>
>>http://lwn.net/images/conf/rtlws11/random-hardware.pdf
>>
>>It basically describes some efforts made in 2009 by folks to do
>>exactly the sort of experiments I was advocating.  What I actually
>
>I am wondering whether you have seen my last measurements where I
>effectively performed the tests you were asking for: disabling all
>possible CPU features and selectively enabling them.
>
>The tests described in the above mentioned documents and much more are
>all already in the test suite and test results I present here.

After this comment, I got back to one of the authors of the cited paper 
(he is in CC).

Here is a quote from his answer to my question whether he was able to 
identify the root cause:

"its inherent in the microtiming of Hardware and there is nothing you 
can do about it if you want the root cause is quantum physics"

That means, no matter how much CPU support you disable, you will always 
have some jitter -- as I showed in my latest test results in appendix 
F.46 of [1]. This statement is supported by my tests on even 
microkernels which have no other job running than my test application. 
Furthermore, as we see that phenomenon on every tested CPU type on every 
tested operating system with every tested compiler, I am wondering what 
else argument is needed to have this solution considered.

[1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html

Ciao
Stephan
