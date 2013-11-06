Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab3KFMVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:21:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:3141 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756493Ab3KFMVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:21:15 -0500
Date: Wed, 6 Nov 2013 07:21:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip v2 3/3] [BUGFIX] kprobes: Prohibit probing on
 func_ptr_is_kernel_text
Message-ID: <20131106072109.28fcb8ca@gandalf.local.home>
In-Reply-To: <20131106060737.GC24044@gmail.com>
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
	<20131101112537.14657.88496.stgit@kbuild-fedora.novalocal>
	<20131104210053.76c37210@gandalf.local.home>
	<20131105060901.GA29936@gmail.com>
	<5278973A.1010705@hitachi.com>
	<20131105070537.GA2007@gmail.com>
	<5278D89B.1070806@hitachi.com>
	<20131106060737.GC24044@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 07:07:37 +0100
Ingo Molnar <mingo@kernel.org> wrote:


> So until compilers get smarter (or there's some compiler trick I haven't 
> noticed) lets stay with the separate section - it's not the end of the 
> world, the (effective) 'noinline' aspect of noprobes changes code 
> generation anyway.
> 

It's fine now. I just wanted everyone to be ware if this annotation
starts to get used a bit more, that it can cause unwanted side effects.

-- Steve
