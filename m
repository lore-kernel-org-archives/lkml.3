Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3KOUKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 15:10:50 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:59532 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3KOUKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 15:10:45 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwGGutF+6dioSFTEsMfXeJysjkt+W_z+qYL7widL2uTtA@mail.gmail.com>
References: <1384180814-21823-1-git-send-email-felipe.contreras@gmail.com>
	<20131113000358.GA2420@gmail.com>
	<CAMP44s17p0ZpFx0Y2E_K7Oq9c4tk2J+9uXRWDYChAD-yM-4JjQ@mail.gmail.com>
	<52850B89.10605@linux.com>
	<52853fe6b0fd9_bf6d31e7c1a@nysa.notmuch>
	<CAMP44s0kGhPvuVZMe4zpmqFLtxrLW2gBPu6eHg0G6DFYKNpW7Q@mail.gmail.com>
	<52861DCB.9020206@linux.com>
	<CAMP44s0q06Qe9BTHTaamFNkic+8_ecATXVACRVNqpRDqw6r5Qg@mail.gmail.com>
	<CA+55aFwGGutF+6dioSFTEsMfXeJysjkt+W_z+qYL7widL2uTtA@mail.gmail.com>
Date: Fri, 15 Nov 2013 14:10:43 -0600
Message-ID: <CAMP44s3q8bc6ENqwetGE1yx9LYA+YdBVmEtok+DwykXLu794DQ@mail.gmail.com>
Subject: Re: [PATCH v2] panic: setup panic_timeout early
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Levente Kurusa <levex@linux.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 1:55 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> It's not just code. You need to also explain *why* people should apply
> it, and stop the f*cking idiotic arguing every time somebody comments
> about your patches.

Doesn't this explain it?

------------------------------------------------------------------------------
panic: setup panic_timeout early

Otherwise we might not reboot when the user needs it the most (early
on).
------------------------------------------------------------------------------

I haven't seen a single complaint about this commit message, so I
don't see what is your point.

You didn't address what I said at all. If the code is technically
correct *and* it is clear there's a reason why the patch should be
applied, who sent the patch should be irrelevant, because even if that
person is problematic, and there's something lacking in the patch,
somebody else can take it from there and fix the remaining issues,
because if there's a reason the patch should be applied, it should be
applied.

In this particular case it is clear we want panic_timeout to work
early on, therefore a patch should be applied to achieve that, and you
might as well simply apply the patch I sent, even though *I* sent it,
because it's technically correct, and the need is explained. Why
wouldn't you?

-- 
Felipe Contreras
