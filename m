Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab3AOKZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:25:43 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:45735 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab3AOKZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:25:42 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 15 Jan 2013 11:25:41 +0100
Message-ID: <CA+icZUUkvBDGkC8x5tUoWmOe6f8sTjLPoadTFhqgUOb91SPC9w@mail.gmail.com>
Subject: Re: [RFC] Reproducible OOM with just a few sleeps
From: Sedat Dilek <sedat.dilek@gmail.com>
To: paul.szabo@sydney.edu.au, Paul Szabo <psz@maths.usyd.edu.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I followed a bit the thread you started in [1].

As you might know i386 got eliminated in Linux-3.8.

I had several discussions with the Debian kernel-team about the iN86
(N=4..6) and PAE kernel-flavours.
On the one hand I can understand the reduction of linux-images
especially for iN86.
Even i486 is a bit unfirm as there is no much hardware around, but
Debian will keep i486 for a while (release maintenance).

Topic PAE:
Unfortunately, I had a notebook with a Intel Centrino Banias CPU (no
PAE) which should use the -486 kernel-flavour due to the Debian
kernel-team.
I played with some different kernel-setup which did not give me more
benefit (openssl benchmarks etc.)
The -686-pae kernel did run on my hardware, but as known with all the
SMP-NO-OPs.

Depending on the hardware, it really makes sense to switch to x86_64
(amd64) architecture when you have a modern computer.
Switching makes even more sense when you have more than 4GiB RAM.
IMHO using a -686-amd64 Debian kernel makes ZERO sense, real 64-Bit or die!

I switched to 64-bit... and I switched from Debian/sid to
Ubuntu/precise as well :-).
( NOTE: I am working here since April 2012 in a WUBI environment (no
native Ubuntu Linux) :-). )

And I am building my kernels by myself.
So I know very well whom to blame :-).

Some last words: I had several fruitful or fruitless discussions with
the Debian kernel-team, but I can confirm (with all my heart) this
team makes a fantastic job.
I can recommend you Ben's blog (recently I read a series about news in
the Debian/wheezy kernel) if your world is Debian or Ubuntu (Debian !=
Ubuntu).

Just my 0.02EUR (no British pound, here as well: when you are a member
of the EU chose EUR not pound!).

Regards,
- Sedat -


[1] http://marc.info/?t=135796172200001&r=1&w=2
