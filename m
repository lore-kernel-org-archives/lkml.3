Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaE0Nnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:43:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51662 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaE0Nn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:43:26 -0400
Date: Tue, 27 May 2014 15:43:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 02/11] sched: remove a wake_affine condition
Message-ID: <20140527134308.GA11074@laptop.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-3-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400860385-14555-3-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 05:52:56PM +0200, Vincent Guittot wrote:
> 
> If sync is set, it's not as straight forward as above (especially if cgroup
> are involved) 

avg load with cgroups is 'interesting' alright.
