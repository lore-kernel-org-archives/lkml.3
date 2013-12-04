Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3LDAgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:36:04 -0500
Received: from tex.lwn.net ([70.33.254.29]:59218 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab3LDAf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:35:59 -0500
Date: Tue, 3 Dec 2013 17:35:57 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 5/5] tracing filter examples in BPF
Message-ID: <20131203173557.636c3d41@lwn.net>
In-Reply-To: <1386044930-15149-6-git-send-email-ast@plumgrid.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<1386044930-15149-6-git-send-email-ast@plumgrid.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Dec 2013 20:28:50 -0800
Alexei Starovoitov <ast@plumgrid.com> wrote:

>  GCC-BPF backend is available on github
>  (since gcc plugin infrastructure doesn't allow for out-of-tree backends)

Do you have a pointer to where this backend can be found?  I've
done a bit of digging around but seem to be unable to find it...

Thanks,

jon
