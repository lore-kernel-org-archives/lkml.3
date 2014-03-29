Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaC2C1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 22:27:18 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:36625 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaC2C1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 22:27:17 -0400
Date: Fri, 28 Mar 2014 22:27:14 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        efault@gmx.de, linaro-kernel@lists.linaro.org
Subject: Re: [RFC 0/4] sched: consolidation of cpu_power
In-Reply-To: <1396012949-6227-1-git-send-email-vincent.guittot@linaro.org>
Message-ID: <alpine.LFD.2.11.1403282217070.1571@knanqh.ubzr>
References: <1396012949-6227-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014, Vincent Guittot wrote:

> Part of this patchset was previously part of the larger tasks packing patchset
> [1]. I have splitted the latter in 3 different patchsets (at least) to make the
> thing easier.
> -configuration of sched_domain topology [2]
> -update and consolidation of cpu_power (this patchset)
> -tasks packing algorithm
> 
> SMT system is no more the only system that can have a CPUs with capacity that
> is different from the default value. We need to extend the use of
> cpu_power_orig to all kind of platform so the scheduler will have both the
> maximum capacity (cpu_power_orig/power_orig) and the current capacity
> (cpu_power/power) of CPUs and groups of the sched_domains.
[...]

Wouldn't it make sense to have a patch in this series that performs some 
s/power/capacity/ throughout the scheduler code before the other patches 
are applied?  That would help getting consistent terminology and avoid 
confusion before real power related metrics are eventually brought into 
the scheduler.


Nicolas
