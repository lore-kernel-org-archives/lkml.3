Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaLVXIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:08:12 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:56301 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaLVXIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:08:09 -0500
From: Grant Coady <gcoady.lk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Drysdale <drysdale@google.com>
Subject: Re: Linux 3.19-rc1 - merge window closed
Date: Tue, 23 Dec 2014 10:08:09 +1100
Organization: scattered
Message-ID: <av8h9ahelpd4e847f4683jh9cpquq2j93p@4ax.com>
References: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com> <1419145899.8696.5.camel@haakon3.risingtidesystems.com> <20141222124310.b35177e67db8d76b64ec55f6@linux-foundation.org>
In-Reply-To: <20141222124310.b35177e67db8d76b64ec55f6@linux-foundation.org>
User-Agent: ForteAgent/7.20.32.1218
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2014 12:43:10 -0800, you wrote:

>On Sat, 20 Dec 2014 23:11:39 -0800 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
>
>> Just hit the following build failure with CONFIG_AUDIT=y:
>> 
>> arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
>> arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
>> arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
>> make[2]: *** [arch/x86/ia32/audit.o] Error 1
>> make[1]: *** [arch/x86/ia32] Error 2
>> make: *** [arch/x86] Error 2
>> make: *** Waiting for unfinished jobs....
>
>Your .config works for me.  Does a `make mrproper' fix it?

Wow. So long since I use make mrproper...

>
>I've seen a few reports like this in recent months.  Something's
>up with the build dependency system.

Yes, but nothing a fresh unpack tarball then start over didn't fix ;o)

Grant.
