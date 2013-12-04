Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3LDACV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:02:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:1239 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab3LDACS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:02:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,821,1378882800"; 
   d="scan'208";a="438034817"
From: Andi Kleen <andi@firstfloor.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
Date: Tue, 03 Dec 2013 16:01:59 -0800
In-Reply-To: <1386044930-15149-1-git-send-email-ast@plumgrid.com> (Alexei
	Starovoitov's message of "Mon, 2 Dec 2013 20:28:45 -0800")
Message-ID: <87fvq9cwlk.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexei Starovoitov <ast@plumgrid.com> writes:

Can you do some performance comparison compared to e.g. ktap?
How much faster is it?

While it sounds interesting, I would strongly advise to make this
capability only available to root. Traditionally lots of complex byte
code languages which were designed to be "safe" and verifiable weren't
really. e.g. i managed to crash things with "safe" systemtap multiple
times. And we all know what happened to Java.

So the likelyhood of this having some hole somewhere (either in
the byte code or in some library function) is high.
 
-Andi 
