Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbaE3R7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:59:43 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:62471 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaE3R7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:59:41 -0400
Date: Fri, 30 May 2014 13:59:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: paolo <paolo.valente@unimore.it>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC RESEND 00/14] New version of the BFQ I/O Scheduler
Message-ID: <20140530175937.GK24871@htj.dyndns.org>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
 <20140530153228.GE16605@redhat.com>
 <20140530161650.GH24871@htj.dyndns.org>
 <20140530170958.GF16605@redhat.com>
 <20140530172609.GI24871@htj.dyndns.org>
 <20140530175527.GH16605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530175527.GH16605@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Fri, May 30, 2014 at 01:55:27PM -0400, Vivek Goyal wrote:
> Now CFQ also dynamically adjusts the slice length based on the how
> many queues are ready to do IO. One problem with fixed slice lenth
> round robin was that if there are lot of queues doing IO, then after
> serving one queue, same queue will get time slice after a long time.
> 
> Corrado Zoccolo did work in this area in an attempt to improve latency.
> Now slice length is calculated dynamically in an attempt to achieve
> better latency.

Consdier it a better version of that.

> Ok, so you prefer to have another IO scheduler instead of improving
> CFQ?

As I wrote in another reply, I think the best approach would be
morphing cfq to accomodate the scheduling algorithm and heristics of
bfq.

> Tejun, I have spent significant amount of time on BFQ few years ago. And
> that's the reason I have not read it again yet. My understanding was
> that there was nothing which would not be done in CFQ (atleast things
> which mattered).

THERE IS A NEW PAPER.

> Looks like you prefer introducing a new scheduler instead of improving
> CFQ. My preference is to improve CFQ. Borrow good ideas from BFQ and
> implement them in CFQ.

LOOKS LIKE YOU ARE NOT READING ANYTHING AND JUST WRITING IRRELEVANT
SHIT.

> So why not improve CFQ instead of carrying and maintaining another 
> scheduler. And then have a discussion that what's the default scheduler.

For fuck's sake, I'm out.  This is total waste of time.  You don't
read what others are writing and refuse to study what's right there.
What are you doing?

-- 
tejun
