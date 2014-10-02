Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaJBVEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:04:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:58501 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaJBVER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:04:17 -0400
Date: Thu, 2 Oct 2014 23:04:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "bsegall@google.com" <bsegall@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] sched: Make sched entity usage tracking
 scale-invariant
Message-ID: <20141002210413.GJ2849@worktop.programming.kicks-ass.net>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-7-git-send-email-morten.rasmussen@arm.com>
 <xm2638bjlgs5.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140923133503.GT23693@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923133503.GT23693@e103034-lin>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:35:03PM +0100, Morten Rasmussen wrote:
> On Mon, Sep 22, 2014 at 06:13:46PM +0100, bsegall@google.com wrote:
> > Morten Rasmussen <morten.rasmussen@arm.com> writes:
> > 
> > > Apply scale-invariance correction factor to usage tracking as well.
> > 
> > It seems like it would make more sense to order the patches as first the
> > usage tracking and then all of the scale-invariance together, or perhaps
> > to just fold this into the usage tracking patch.
> 
> Makes sense. I don't mind reordering the patches. Vincent has already
> got some of the usage bits in his patch set, so I will have to rework
> the usage patches anyway if Peter decides to take the rest of Vincent's
> patch set.

Yes, please reorder. I'll try and get back to wrapping brain around the
rest of Vincent's patches. Had to put that on hold to avoid getting
burried under incoming bits.
