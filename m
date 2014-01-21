Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaAUJGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:06:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46592 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaAUJG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:06:28 -0500
Date: Tue, 21 Jan 2014 10:06:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: Re: [PATCH 4/4] sched: Idle task shortcut optimization
Message-ID: <20140121090609.GP31570@twins.programming.kicks-ass.net>
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
 <1389949444-14821-4-git-send-email-daniel.lezcano@linaro.org>
 <20140117142644.GI11314@laptop.programming.kicks-ass.net>
 <52D94705.1000407@linaro.org>
 <20140117152310.GK11314@laptop.programming.kicks-ass.net>
 <52D94B95.2060704@linaro.org>
 <20140117153323.GM11314@laptop.programming.kicks-ass.net>
 <52DE32BB.4010006@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DE32BB.4010006@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 09:41:31AM +0100, Daniel Lezcano wrote:
> On 01/17/2014 04:33 PM, Peter Zijlstra wrote:
> >On Fri, Jan 17, 2014 at 04:26:13PM +0100, Daniel Lezcano wrote:
> >>
> >>Ah, ok. Let me try it.
> >>
> >
> >http://programming.kicks-ass.net/sekrit/patches.tar.bz2
> >
> >has a queue that applies to tip/master.
> >
> >The patches as on lkml need a little help in applying.
> >
> >They've not been near a compiler yet though :/
> 
> Hi Peter,
> 
> do you want me to resend the full serie with your patchset included ?

Nah, I'll send it out, I wanted PJT or Ben to look over one more patch I
did, meant to do that yesterday but you know how those things go :-)
