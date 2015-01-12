Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbbALNz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:55:27 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:42684 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbbALNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:55:25 -0500
Date: Mon, 12 Jan 2015 08:55:21 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 10/12] sched: use {cpu|node}mask pr_cont and seq output
 functions
Message-ID: <20150112135521.GZ25319@htj.dyndns.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
 <1418226774-30215-11-git-send-email-tj@kernel.org>
 <20141215103915.GX29390@twins.programming.kicks-ass.net>
 <20150112133145.GY25319@htj.dyndns.org>
 <20150112135034.GC25256@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112135034.GC25256@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 02:50:34PM +0100, Peter Zijlstra wrote:
> See this thread:
>   https://lkml.org/lkml/2012/5/9/416
>   https://lkml.org/lkml/2012/5/9/353
> 
> At the time I couldn't make it work :/

Dang, I was worrying about the same thing, so the compiler does
complain about using precision with a pointer. :(

-- 
tejun
