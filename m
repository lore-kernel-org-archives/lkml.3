Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaKYRgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:36:47 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:50850 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaKYRgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:36:45 -0500
MIME-Version: 1.0
In-Reply-To: <20141125115003.856641273@goodmis.org>
References: <20141125115003.856641273@goodmis.org>
Date: Tue, 25 Nov 2014 09:36:44 -0800
X-Google-Sender-Auth: hbZieMtdYFdHBH1Ccx0RKee7f-c
Message-ID: <CA+55aFwtLAOVGz5h8+zJ8PgoVwiyHHrfMnxpKtpR98N6y0nBKg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/9 v2] ftrace/x86: Clean up of mcount.S code
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 3:50 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I ran these through my test suite and they passed. Are these changes
> fine for you? If so, I'll include them in my 3.19 queue.

Yeah, the end result here looks much more understandable.

Or maybe it's just that I've now seen so many versions that it doesn't
look strange to me any more.

Either way, this looks ok. Maybe some other x86 asm person can look at
it, but if you get the right backtraces it can't be too broken.

                     Linus
