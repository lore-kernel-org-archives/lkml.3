Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbaGNQaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:30:09 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38363 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbaGNQaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:30:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140714161713.GD9918@twins.programming.kicks-ass.net>
References: <1405353439-14211-1-git-send-email-jolsa@kernel.org>
 <20140714160947.GB9918@twins.programming.kicks-ass.net> <CALCETrWZChK=p2v+-ez7s04ed5POawSqGrvST24m0c1TjFMVxw@mail.gmail.com>
 <20140714161713.GD9918@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 14 Jul 2014 09:29:43 -0700
Message-ID: <CALCETrWdY9mj3cGcebJ6jJ1YA6werwfPFf3cqUEAGa77mPD=dQ@mail.gmail.com>
Subject: Re: [PATCH] perf: Add vm_ops->name call for mmap event name retrieval
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 9:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jul 14, 2014 at 09:14:41AM -0700, Andy Lutomirski wrote:
>> Looks good to me.  Sorry I missed that.
>>
>
> Can I make that an Acked-by?

Acked-by: Andy Lutomirski <luto@amacapital.net>

--Andy
