Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbaCSMGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:06:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59065 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbaCSMGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:06:24 -0400
Date: Wed, 19 Mar 2014 13:05:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
        preeti@linux.vnet.ibm.com, tony.luck@intel.com, fenghua.yu@intel.com,
        schwidefsky@de.ibm.com, james.hogan@imgtec.com, cmetcalf@tilera.com,
        benh@kernel.crashing.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 7/7] sched: powerpc: Add SD_SHARE_POWERDOMAIN for SMT
 level
Message-ID: <20140319120555.GL27632@laptop.programming.kicks-ass.net>
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
 <1395165409-18055-8-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395165409-18055-8-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 06:56:49PM +0100, Vincent Guittot wrote:
> Set the power domain dependency at SMT level of Power8 but keep the flag
> clear at CPU level. The goal is to consolidate tasks on the threads of a
> core up to a level as decribed in the link below:
> https://lkml.org/lkml/2014/3/12/16

I've not yet looked at the link; but its best to avoid references and
have a Changelog that can stand on its own.
