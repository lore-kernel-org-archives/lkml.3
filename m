Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3IZPo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:44:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53195 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab3IZPoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:44:25 -0400
Date: Thu, 26 Sep 2013 17:44:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for
 wake_affine(.sync=true)
Message-ID: <20130926154419.GF3657@laptop.programming.kicks-ass.net>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
 <1380099377.8523.9.camel@marge.simpson.net>
 <20130926095812.GR3081@twins.programming.kicks-ass.net>
 <52444E3A.5070503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52444E3A.5070503@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 11:09:46PM +0800, Michael wang wrote:
> > +	if (sync)
> > +		p->se.last_sync_wakeup = sched_clock_cpu(cpu);
> 
> Forgive me but I'm trying to understand it... why not 'current' but 'p'
> here? we want the get off speed of waker or the working time of wakee?

Because I'm an idiot? ;-)
