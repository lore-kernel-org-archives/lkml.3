Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3KSDdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:33:15 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:34465 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3KSDdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:33:12 -0500
MIME-Version: 1.0
In-Reply-To: <20131119032818.GC10323@ZenIV.linux.org.uk>
References: <FB8A4655DFD2B34DB16AE06DDDD6C0E21BDB93D2@SJEXCHMB12.corp.ad.broadcom.com>
	<20131119012042.GA10323@ZenIV.linux.org.uk>
	<alpine.LFD.2.10.1311181912090.7995@i7.linux-foundation.org>
	<20131119032818.GC10323@ZenIV.linux.org.uk>
Date: Mon, 18 Nov 2013 19:33:11 -0800
X-Google-Sender-Auth: GuKaV3EoY5jofW4vZrvoWRx7SiQ
Message-ID: <CA+55aFzp6tssRriEq6GoNvXDjtO07X5_9BT3+fhk3Y7=7dx77w@mail.gmail.com>
Subject: Re: [PATCH] FS: Fixed buffer overflow issue in seq_read()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Charley (Hao Chuan) Chu" <charley.chu@broadcom.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 7:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> BTW, I've several old commits that didn't go into the first pile (e.g.
> taking read_seqbegin_or_lock() and friends from fs/dcache.c into
> linux/seqlock.h, where they obviously belong, etc.) and several regression
> fixes; are you OK with pull request tomorrow?  I can post it tonight,
> but I'd prefer to leave local toruture running overnight...

Tomorrow's fine.

           Linus
