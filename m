Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab3KKVPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:15:41 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44233 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3KKVPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:15:33 -0500
Date: Mon, 11 Nov 2013 22:15:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, x86@kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip RFC 0/2] kprobes: introduce NOKPROBE_SYMBOL() and
 prohibit probing on .entry.text
Message-ID: <20131111211530.GA19316@gmail.com>
References: <20131108125213.19972.49271.stgit@kbuild-fedora.novalocal>
 <20131111111618.GA15810@gmail.com>
 <5281117D.3010202@hitachi.com>
 <20131111122537.5c3192d2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111122537.5c3192d2@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 12 Nov 2013 02:18:53 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> > > After that we can convert all the rest, probably as part of this series.
> > 
> > OK, I'll do. :)
> > BTW, converting all the __kprobes involves many archs, which
> > kprobes ported. In that case, which mailing-list would better me
> > to post the series, linux-arch?
> 
> I would add linux-arch.
> 
> Note, you may need to support both ways for the current time being, as 
> new __kprobes are being added (I've seen several in patches flying by in 
> LKML).

We'd rather like to know about all cases where new code is added to 
kprobes (or where we missed to consider some existing code).

It's really just a handful of annotations, the brunt of which is internal 
to kprobes.

Thanks,

	Ingo
