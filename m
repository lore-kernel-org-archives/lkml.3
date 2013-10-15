Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3JOLPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:15:19 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:40265 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3JOLPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:15:17 -0400
MIME-Version: 1.0
In-Reply-To: <20131015110409.GG10651@twins.programming.kicks-ass.net>
References: <1381833986-19393-1-git-send-email-artagnon@gmail.com> <20131015110409.GG10651@twins.programming.kicks-ass.net>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 15 Oct 2013 16:44:36 +0530
Message-ID: <CALkWK0mWn2OKn4o4zLWz0Vck8DNT0kreq-c83oQkkx4LSO-42w@mail.gmail.com>
Subject: Re: [PATCH] perf tools: use ansi versions of asm and volatile
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, Oct 15, 2013 at 04:16:26PM +0530, Ramkumar Ramachandra wrote:
>> asm and volatile are provided for backward compatibility; use the ansi
>> versions __asm__ and __volatile__.
>>
>
> I won't object much to this; but I have to note that the entire kernel
> tree is loaded with the non-ansi variant and thus we're fairly certain
> it will continue working :-)

Oh well, atleast the definition of barrier() is consistent with the
one in linux/compiler-gcc.h.
