Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbaDXQyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:54:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaDXQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:54:10 -0400
Date: Thu, 24 Apr 2014 18:54:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 3/3] sched, fair: Stop searching for tasks in newidle
 balance if there are runnable tasks
Message-ID: <20140424165403.GY11096@twins.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
 <1398303035-18255-4-git-send-email-jason.low2@hp.com>
 <20140424071541.GZ26782@laptop.programming.kicks-ass.net>
 <1398357789.3509.6.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398357789.3509.6.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 09:43:09AM -0700, Jason Low wrote:
> I recall seeing somewhere around a +7% performance improvement
> in at least least 1 of the AIM7 workloads. I can do some more testing
> with this.

But yeah, please test more than 1 workload; its fairly typical for one
workload to win and another to completely tank :-/
