Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab3GEUTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:19:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:46392 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3GEUT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:19:29 -0400
Date: Fri, 5 Jul 2013 22:19:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Waiman Long <Waiman.Long@hp.com>
cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v5 02/12] spinlock: Enable x86 architecture to do lockless
 refcount update
In-Reply-To: <1373035656-40600-3-git-send-email-Waiman.Long@hp.com>
Message-ID: <alpine.DEB.2.02.1307052217500.32106@ionos.tec.linutronix.de>
References: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com> <1373035656-40600-3-git-send-email-Waiman.Long@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, Waiman Long wrote:

> There are two steps to enable each architecture to do lockless
> reference count update:
> 1. Define the ARCH_SPINLOCK_REFCOUNT config parameter in its Kconfig
>    file.

No, we select GENERIC_SPINLOCK_REFCOUNT unless we provide an
architecture specific implementation. In that case we select
ARCH_SPINLOCK_REFCOUNT.

Thanks,

	tglx
