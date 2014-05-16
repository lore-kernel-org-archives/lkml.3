Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaEPCvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 22:51:36 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:59711 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbaEPCve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 22:51:34 -0400
Message-ID: <1400208690.7133.11.camel@marge.simpson.net>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Date: Fri, 16 May 2014 04:51:30 +0200
In-Reply-To: <5375768F.1010000@linux.vnet.ibm.com>
References: <20140513094737.GU30445@twins.programming.kicks-ass.net>
	 <53721FD4.6060300@redhat.com>
	 <20140513142328.GE2485@laptop.programming.kicks-ass.net>
	 <53731D12.7040804@linux.vnet.ibm.com>
	 <20140514094426.GF30445@twins.programming.kicks-ass.net>
	 <5374387E.4080802@linux.vnet.ibm.com>
	 <20140515083531.GE30445@twins.programming.kicks-ass.net>
	 <53747EE4.3020605@linux.vnet.ibm.com>
	 <20140515090638.GI30445@twins.programming.kicks-ass.net>
	 <53748A5D.6070605@linux.vnet.ibm.com>
	 <20140515115751.GK30445@twins.programming.kicks-ass.net>
	 <5375768F.1010000@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 10:23 +0800, Michael wang wrote:

> But we found that one difference when group get deeper is the tasks of
> that group become to gathered on CPU more often, some time all the
> dbench instances was running on the same CPU, this won't happen for l1
> group, may could explain why dbench could not get CPU more than 100% any
> more.

Right.  I played a little (sane groups), saw load balancing as well.

-Mike

