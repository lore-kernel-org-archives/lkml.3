Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaD1CY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:24:56 -0400
Received: from ozlabs.org ([103.22.144.67]:39653 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbaD1CYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:24:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] ftrace/module: Hardcode ftrace_module_init() call into load_module()
In-Reply-To: <20140424105417.7407bb72@gandalf.local.home>
References: <20140424105417.7407bb72@gandalf.local.home>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 28 Apr 2014 10:54:20 +0930
Message-ID: <87lhuqtfej.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> [
>   Rusty, you can take this patch, or if you want, you can give me 
>   an Acked-by, and I'll push this through my tree.
> ]

Assuming you want this in the current kernel, I'll just ack:

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Since I've got my "make RO/NX earlier" patch queued for *next*
window, and yours need to go in before that...

Thanks,
Rusty.
