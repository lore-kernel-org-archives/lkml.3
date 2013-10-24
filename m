Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3JXJmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:42:40 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:63419 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3JXJmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:42:38 -0400
MIME-Version: 1.0
In-Reply-To: <1382604360.5283.9.camel@pippen.local.home>
References: <20131024075813.GA26929@gmail.com>
	<1382604360.5283.9.camel@pippen.local.home>
Date: Thu, 24 Oct 2013 10:42:37 +0100
X-Google-Sender-Auth: tsTLUb2liHaXJQHltsMKxO-r3EY
Message-ID: <CA+55aFxiNnpWSrA7GVHjsDsd6+a3XScDUAhpL7XPQ7F6g1-iJA@mail.gmail.com>
Subject: Re: ktap inclusion in drivers/staging/?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jovi.zhangwei@huawei.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 9:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> But I agree, this should not be just dumped into the staging tree until
> the patches themselves have been posted and reviewed.

Btw, it's not just the commit history. The actual file layout is
terminally horrible too. The actual LWN article made it look like ktap
was just a user-space tool, and I was thinking that it was like
tools/pert/, just in staging.

But looking at the tree, it looks like parts of it is a kernel module,
and parts of it is the user space thing, and it's totally impossible
to see which is which, it's just all mixed up in the same directory
structure.

Maybe I misunderstood, but that was my reaction from a very quick look.

               Linus
