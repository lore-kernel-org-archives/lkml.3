Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3LDJYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:24:44 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49784 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3LDJYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:24:39 -0500
Date: Wed, 4 Dec 2013 10:24:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 3/5] Extended BPF (64-bit BPF) design document
Message-ID: <20131204092435.GB32531@gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
 <1386044930-15149-4-git-send-email-ast@plumgrid.com>
 <529E0E69.90009@zytor.com>
 <CAMEtUuxENa69dMdhmZg=tSJ_mWaYAy_JqBF2NXxkqbaAxawFkw@mail.gmail.com>
 <y0mpppdr7k7.fsf@fche.csb>
 <CAMEtUuxvBP+HXpfUk41VkMOO6e__igmQqQUKpR28C1Us9E8LjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuxvBP+HXpfUk41VkMOO6e__igmQqQUKpR28C1Us9E8LjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexei Starovoitov <ast@plumgrid.com> wrote:

> It's possible to teach it for multi-level, but then analyzer will 
> become too large and won't be suitable for kernel.

Btw., even if we want to start simple with most things, the above 
statement is not actually true in the broad sense: the constraint for 
the kernel is utility, not complexity.

We have various kinds of highly complex code in the kernel and can 
deal with it just fine. Throwing away useful ideas just because they 
seem too complex at first sight is almost always wrong.

Thanks,

	Ingo
