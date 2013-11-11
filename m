Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3KKUlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:41:20 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:47702 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3KKUlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:41:10 -0500
Date: Mon, 11 Nov 2013 21:41:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf record: mmap output file - v4
Message-ID: <20131111204104.GB18886@gmail.com>
References: <1383884605-30968-1-git-send-email-dsahern@gmail.com>
 <1383884605-30968-3-git-send-email-dsahern@gmail.com>
 <20131111112906.GE15810@gmail.com>
 <20131111145804.GB27198@ghostprotocols.net>
 <5280F50E.6010700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5280F50E.6010700@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 11/11/13, 7:58 AM, Arnaldo Carvalho de Melo wrote:
> >
> >>Looks very clean now!
> >
> >>Acked-by: Ingo Molnar <mingo@kernel.org>
> >
> >Applied the prep patch, but waiting for v5 as stated by David when
> >answering Jiri's concerns.
> 
> I'll re-send - giving some time for comments on the use of 
> setjmp/longjmp to bounce out of memcpy and error exit when filesystem 
> runs out of space.

Maybe that could be an add-on patch instead?

All the rest would already be an improvement, right?

Thanks,

	Ingo
