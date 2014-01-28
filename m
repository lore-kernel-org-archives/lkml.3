Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaA1SHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:07:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:9326 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754599AbaA1SHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:07:40 -0500
Date: Tue, 28 Jan 2014 13:07:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, daniel.lezcano@linaro.org,
        pjt@google.com, bsegall@google.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH 0/9] Various sched patches -v2
Message-ID: <20140128130734.2ddb595b@gandalf.local.home>
In-Reply-To: <20140128171634.974847076@infradead.org>
References: <20140128171634.974847076@infradead.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014 18:16:34 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> Here's a set that seems to work properly and hopefully adresses all previously
> raised issues.
> 
> Daniel, I'm sorry, the idle_stamp thing wandered back over to fair.c :-)
> 
> I did test the fair bits, including bandwidth (although not very
> extensively).
> 
> I did not test the dl/rt bits, Steve do you have a testcase for that?


My sched tests are usually done by running some scheduling tests while
recording sched switches and then analyzing it under kernelshark. I
don't have many other tests that do pass fail. Hmm, I did have a couple
of rt migration tests, but that's it.

I'll take a look at theses tomorrow.

-- Steve

