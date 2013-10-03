Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab3JCHn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:43:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39293 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3JCHn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:43:27 -0400
Date: Thu, 3 Oct 2013 09:43:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] introduce synchronize_sched_{enter,exit}()
Message-ID: <20131003074301.GZ3081@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-38-git-send-email-mgorman@suse.de>
 <20130917143003.GA29354@twins.programming.kicks-ass.net>
 <20130929183634.GA15563@redhat.com>
 <20131002144125.GS3081@twins.programming.kicks-ass.net>
 <20131003070459.GB5320@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003070459.GB5320@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 09:04:59AM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > 
> 
> Fully agreed! :-)

haha.. never realized I send that email completely empty. It was
supposed to contain the patch I later send as 2/3.
