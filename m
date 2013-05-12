Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3ELBQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 21:16:09 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:48821 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3ELBQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 21:16:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130511001206.477862307@goodmis.org>
References: <20130511001206.477862307@goodmis.org>
Date: Sat, 11 May 2013 18:16:07 -0700
X-Google-Sender-Auth: NdhnUub9wv3kuL4o3FGG2pSdFrE
Message-ID: <CA+55aFyftw6uxJ=pO4DgN7ZrKxE5X-cbQahMjKKu6Rb++EGhqQ@mail.gmail.com>
Subject: Re: [PATCH 00/18] tracing/kprobes: Update kprobes with new ftrace changes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 5:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Linus,
>
> The majority of these changes are from Masami Hiramatsu bringing
> kprobes up to par with the latest changes to ftrace (multi buffering
> and the new function probes).

So I pulled this just before doing -rc1, and I'm a bit worried about
"make allmodconfig" resulting in these new warnings:

   WARNING: "ring_buffer_event_data" [*/*/*.ko] has no CRC!

but the kernel I actually install and boot doesn't show that, so I
don't know if this then actually causes problems. And since I wasn't
going to do a kernel release tomorrow, I shipped -rc1 as-is.

Please do check it out and send me a fix, though.

                  Linus
