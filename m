Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbaIZXcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:32:25 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:62619 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbaIZXcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140926170041.700f44bd@as>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com>
	<20140926170041.700f44bd@as>
Date: Fri, 26 Sep 2014 16:32:22 -0700
X-Google-Sender-Auth: XIvXRiNAn-oDKbFvhfuxugKGoLY
Message-ID: <CA+55aFzMdWY6o512mXeOz6Mv7dWYn6W7csLDCsqhSGssRbsHLw@mail.gmail.com>
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Anish Bhatt <anish@chelsio.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Anvin <hpa@zytor.com>, sebastian@fds-team.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 3:00 PM, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
>
> I don't get it. Why isn't this patch acceptable, at least on x86-64
> where NT is never valid?

Why do you think it's not acceptable? Why do you raise a stink *one*
day after the patch - that seems to not be very important - is sent
out?

Why would SIGSEGV even be that bad? The program does crap things, why
accept it silently?

I don't think the patch is necessarily wrong, but I don't see why it
would be critical, and I *definitely* don't see why the f*ck you are
making a big deal of it.

Go away, stop bothering people.

         Linus
