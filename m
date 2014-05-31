Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaEaOzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:55:55 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49845 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaEaOzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:55:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        hpa@zytor.com, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 03/32] fs: introduce sys_utimens64at
Date: Sat, 31 May 2014 16:55:44 +0200
Message-ID: <4824036.97Kbggn7gm@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <m2ppiul2u9.fsf@linux-m68k.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-4-git-send-email-arnd@arndb.de> <m2ppiul2u9.fsf@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xwENQ5l2EV0BKdpohJQWob0WRApm8jgHUmQCVnBEpkc
 cuodAvzvnjlYMMzh9F+QqbMZHHx1w6aaSwJZFczVv6Na/GvKJ8
 EpAJq4bgFIwI/M8Wn//HLD60nSe/gwrXGmoBOLHXAayqlEurH/
 InvOrberaT0GXzqONO/aE5f+P0zXSTpOCeS7fnGgAtKYFbUuKn
 X4ccXSx+q8x/cyOxo6tD68mQoPpUfxLEiPWUtaPfJ+KQK+kU8N
 k5RpAKdeSszB4Cfqy8VKqTgrCetEUgX3iKERgfLDjsCJ8NEYv+
 57OvHNT7njdOow/83OLQ5Urs/EO8/Cn9CFFZkHX/il7Jm3uSoV
 AHkgResIBg6RZkiIx7Vo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2014 11:22:38 Andreas Schwab wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> 
> > +asmlinkage long sys_utimens64at(int dfd, const char __user *filename,
> 
> All existing syscall names have the 64 suffix last, including the *at
> variants, so sys_utimensat64 would be more in line.

Ok, makes sense. I actually typed utimensat64 a few times myself and
couldn't really decide which one to use.

	Arnd
