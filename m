Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3HaPuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 11:50:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30116 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3HaPuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 11:50:07 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=YkRx-0dWRqIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fqwXYugPWpcA:10 a=T0GvGfYZ6J1WWgEwxkgA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Sat, 31 Aug 2013 11:50:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 00/18 v2] ftrace/rcu: Handle unsafe RCU functions
 and ftrace callbacks
Message-ID: <20130831115003.59db9de3@gandalf.local.home>
In-Reply-To: <20130831051117.884125230@goodmis.org>
References: <20130831051117.884125230@goodmis.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Aug 2013 01:11:17 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> This is my final draft of the patches. I'm starting to run them
> through my formal tests now. They may change depending on the outcome
> of the tests.

Update: All my formal tests passed.

> 
> I'm also a bit tired, and I added the change logs last. Thus I may
> need to go back and fix the change logs up too. But the code was done
> when I was rather spunky. But that doesn't mean I didn't break anything.

I still probably need to update the change logs.

But other than that, I'm waiting on Acks or comments.

Thanks!

-- Steve

