Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaCXSzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 14:55:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:22441 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753583AbaCXSzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 14:55:53 -0400
Date: Mon, 24 Mar 2014 14:55:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, fche@redhat.com,
        mingo@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        systemtap@sourceware.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH -tip v8 03/26] kprobes: Prohibit probing on .entry.text
 code
Message-ID: <20140324145551.1af360bb@gandalf.local.home>
In-Reply-To: <20140305115904.22766.57607.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305115904.22766.57607.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 20:59:04 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> .entry.text is a code area which is used for interrupt/syscall
> entries, and there are many sensitive codes.
> Thus, it is better to prohibit probing on all of such codes
> instead of a part of that.
> Since some symbols are already registered on kprobe blacklist,
> this also removes them from the blacklist.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
