Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352AbaFTEp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:45:59 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44869 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbaFTEp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:45:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140619213952.058255809@goodmis.org>
References: <20140619213329.478113470@goodmis.org>
	<20140619213952.058255809@goodmis.org>
Date: Thu, 19 Jun 2014 18:45:57 -1000
X-Google-Sender-Auth: 5LCKam_eo2FgEoynRkX1tm4ED84
Message-ID: <CA+55aFx_BVK6EvMTcTy218coYEhvMdw3AkygDtiZk5aHxa-fuA@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 11:33 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>
> The trace_seq functions are rather useful outside of tracing.

They are? Why and where? And why are they still called "trace_xyz()" then?

That commit message is useless and contains no actual information.

                 Linus
