Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3FRKDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:03:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39917 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab3FRKDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:03:44 -0400
Date: Tue, 18 Jun 2013 12:03:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: mingo@redhat.com, linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 3/3] sched: remove WARN_ON(!sd) from
 init_sched_groups_power()
Message-ID: <20130618100340.GM3204@twins.programming.kicks-ass.net>
References: <cover.1370948150.git.viresh.kumar@linaro.org>
 <2bbe633cd74b431c05253a8ce61fdfd5066a531b.1370948150.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bbe633cd74b431c05253a8ce61fdfd5066a531b.1370948150.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 04:32:45PM +0530, Viresh Kumar wrote:
> sd can't be NULL in init_sched_groups_power() and so checking it for NULL isn't
> useful. In case it is required, then also we need to rearrange the code a bit as
> we already accessed invalid pointer sd to get sg: sg = sd->groups.
> 

Err on the side of paranoia :-)
