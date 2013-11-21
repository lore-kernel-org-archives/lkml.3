Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3KULaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:30:17 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:41587 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab3KULaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:30:10 -0500
Date: Thu, 21 Nov 2013 12:30:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Vineet Gupta <vgupta@synopsys.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v3 18/23] x86/dumpstack: Use NOKPROBE_SYMBOL macro
 in dumpstack.c
Message-ID: <20131121113006.GA27659@gmail.com>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
 <20131120042233.15296.31189.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120042233.15296.31189.stgit@kbuild-fedora.novalocal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Use NOKPROBE_SYMBOL macro for protecting functions
> from kprobes instead of __kprobes annotation in
> dumpstack.c.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> ---
>  arch/x86/kernel/dumpstack.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Btw., all these mechanic changes of the __kprobes annotation can be 
merged into a single patch. That will cut down on the size of the 
series substantially.

Thanks,

	Ingo
