Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964882AbaH0SyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:54:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbaH0SyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:54:06 -0400
Date: Wed, 27 Aug 2014 20:51:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] x86, fpu: copy_process's FPU paths cleanups
Message-ID: <20140827185138.GA12487@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Who can review this? And where should I send FPU changes?

And it seems that nobody cares about 2 fixes I sent before.
Linus, I understand that you won't take them into v3.17, but
perhaps you can ack/nack them explicitly? It seems that nobody
can do this.

Oleg.

 arch/x86/include/asm/fpu-internal.h |    2 +-
 arch/x86/kernel/process.c           |   16 +++++++++-------
 arch/x86/kernel/process_32.c        |    2 --
 arch/x86/kernel/process_64.c        |    1 -
 4 files changed, 10 insertions(+), 11 deletions(-)

