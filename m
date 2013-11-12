Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3KLKuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:50:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55530 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3KLKuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:50:09 -0500
Date: Tue, 12 Nov 2013 11:49:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        Morten.Rasmussen@arm.com, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        l.majewski@samsung.com
Subject: Re: [RFC][PATCH v5 08/14] sched: move load idx selection in
 find_idlest_group
Message-ID: <20131112104951.GI4971@laptop.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <1382097147-30088-8-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382097147-30088-8-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 01:52:21PM +0200, Vincent Guittot wrote:
> load_idx is used in find_idlest_group but initialized in select_task_rq_fair
> even when not used. The load_idx initialisation is moved in find_idlest_group
> and the sd_flag replaces it in the function's args.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Thanks applied!
