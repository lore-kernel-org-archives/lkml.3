Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaEaNqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 09:46:52 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35450 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514AbaEaNqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 09:46:50 -0400
X-Auth-Info: yC9awi808YUcBuyeVa/8/x2R/lCYMt5WOkWZiC+R5TQ=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC 01/32] fs: introduce new 'struct inode_time'
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<1401480116-1973111-2-git-send-email-arnd@arndb.de>
	<CAMuHMdVgch4REGcYWFZXVToX2b8iCinFVV10Bz3VoeiZy_yBtg@mail.gmail.com>
	<m2tx86l4ux.fsf@linux-m68k.org>
	<CAMuHMdXPQQpu_6k+Y6o=1u-u9EkkanKdGYp6-=BavyYHUH3AuA@mail.gmail.com>
X-Yow: If elected, Zippy pledges to each and every American
 a 55-year-old houseboy...
Date: Sat, 31 May 2014 15:46:42 +0200
In-Reply-To: <CAMuHMdXPQQpu_6k+Y6o=1u-u9EkkanKdGYp6-=BavyYHUH3AuA@mail.gmail.com>
	(Geert Uytterhoeven's message of "Sat, 31 May 2014 15:19:48 +0200")
Message-ID: <87wqd2f4cd.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> "int" is signed, right? Or do you mean a bitfield needs an explicit "signed"
> keyword to be signed?

Yes, see 6.7.2#5.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
