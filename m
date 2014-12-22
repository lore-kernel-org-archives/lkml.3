Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbaLVUnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:43:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaLVUnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:43:12 -0500
Date: Mon, 22 Dec 2014 12:43:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Drysdale <drysdale@google.com>
Subject: Re: Linux 3.19-rc1 - merge window closed
Message-Id: <20141222124310.b35177e67db8d76b64ec55f6@linux-foundation.org>
In-Reply-To: <1419145899.8696.5.camel@haakon3.risingtidesystems.com>
References: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com>
	<1419145899.8696.5.camel@haakon3.risingtidesystems.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2014 23:11:39 -0800 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> Just hit the following build failure with CONFIG_AUDIT=y:
> 
> arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
> arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
> arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
> make[2]: *** [arch/x86/ia32/audit.o] Error 1
> make[1]: *** [arch/x86/ia32] Error 2
> make: *** [arch/x86] Error 2
> make: *** Waiting for unfinished jobs....

Your .config works for me.  Does a `make mrproper' fix it?

I've seen a few reports like this in recent months.  Something's
up with the build dependency system.
