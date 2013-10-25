Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3JYB3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 21:29:32 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:54320 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3JYB3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 21:29:31 -0400
MIME-Version: 1.0
In-Reply-To: <87mwlyclng.fsf@rustcorp.com.au>
References: <1382498320-26594-1-git-send-email-tom.leiming@gmail.com>
	<87eh7bfoq9.fsf@rustcorp.com.au>
	<20131024084559.GD16735@n2100.arm.linux.org.uk>
	<87mwlyclng.fsf@rustcorp.com.au>
Date: Fri, 25 Oct 2013 09:29:30 +0800
Message-ID: <CACVXFVO86u0h0V-1_DCkO5HNyUp2i_UsjPrVWDb-ZBtmwVk28A@mail.gmail.com>
Subject: Re: [RFC PATCH] kernel/kallsyms.c: only show legal kernel symbol
From: Ming Lei <tom.leiming@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chen Gang <gang.chen@asianux.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 7:08 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> Sorry, I was imprecise.  I was referring to the kernel's kallsyms
> tables produced by scripts/kallsyms.c.  This patch left them in the
> the kallsyms tables and filtered them out from /proc/kallsyms.

Yes, but it isn't easy to do it by script/kallsyms.c , and IMO, it should
be correct to hide them for user space but keep them in kallsyms table.

>
> It's weird that cpu_v7_suspend_size appeared above, since kallsyms
> should filter out 'A' symbols already.

Sorry, the 'A' symbol is a mistake, but the others do exist in /proc/kallsyms.


Thanks,
-- 
Ming Lei
