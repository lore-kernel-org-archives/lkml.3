Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762167Ab3JPVCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 17:02:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761953Ab3JPVCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 17:02:35 -0400
Date: Wed, 16 Oct 2013 22:55:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] (Was: perf_event_mmap(vma) && !vma->vm_mm)
Message-ID: <20131016205531.GA26066@redhat.com>
References: <20131012192203.GA21738@redhat.com> <20131014102426.GX3081@twins.programming.kicks-ass.net> <20131016200924.GA23214@redhat.com> <20131016202822.GI2675@laptop.programming.kicks-ass.net> <20131016204348.GA25121@redhat.com> <20131016205559.GF10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016205559.GF10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Peter Zijlstra wrote:
>
> On Wed, Oct 16, 2013 at 10:43:48PM +0200, Oleg Nesterov wrote:
> > Yes, we can copy the garbage to the userspace. So what? This should not
> > matter at all. Exactly because userspace should never used the data after
> > the end of string, no?
>
> Security people tell me to _never_ leak anything. I'm not near creative
> enough to exploit such a thing; but I am amazed at the techniques I do
> read about at times. So its really a better safe than sorry thing.

OK.

Still we can cleanup/simplify this. see the next email...

Oleg.

