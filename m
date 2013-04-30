Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3D3LLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:11:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44512 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760213Ab3D3LLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:11:23 -0400
Date: Tue, 30 Apr 2013 13:11:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
Subject: Re: [PATCH -tip 1/4] sched: Avoid cputime scaling overflow
Message-ID: <20130430111119.GA28821@gmail.com>
References: <1367314507-9728-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367314507-9728-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Here is patch, which add Linus cputime scaling algorithm to the kernel.
> 
> This is follow up of commit d9a3c9823a2e6a543eb7807fb3d15d8233817ec5
> "sched: Lower chances of cputime scaling overflow" which try to avoid
> multiplication overflow, but not guarantee that the overflow will not
> happen.
> 
> Linus crated different algorithm, which avoid completely multiplication
> overflow by dropping precision when numbers are big. It was tested
> by me and it gives good relative error of scaled numbers.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

For multi-authored code it's generally nice to add a tag like this:

   Originally-From: Linus Torvalds <torvalds@linux-foundation.org>

It would also be nice to quote the testing results/output and the 
precision estimations in the changelog - so that others can see the code's 
current capabilities and limitations.

Thanks,

	Ingo
