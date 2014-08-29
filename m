Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaH2EBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 00:01:11 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:42195 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750720AbaH2EBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 00:01:09 -0400
Message-ID: <1409284859.25020.3.camel@rojo>
Subject: Re: [PATCH] vexpress/spc: fix a build warning on array bounds
From: Pawel Moll <pawel.moll@arm.com>
To: Alex Shi <alex.shi@linaro.org>, arm@kernel.org
Cc: Sudeep Holla <Sudeep.Holla@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mark.brown@linaro.org" <mark.brown@linaro.org>,
        "tixy@linaro.org" <tixy@linaro.org>
Date: Thu, 28 Aug 2014 21:00:59 -0700
In-Reply-To: <53FFDB50.3060904@linaro.org>
References: <1405509716-19591-1-git-send-email-alex.shi@linaro.org>
	 <53C661CB.7040306@arm.com> <53FFDB50.3060904@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-08-29 at 02:45 +0100, Alex Shi wrote:
> On 07/16/2014 07:28 PM, Sudeep Holla wrote:
> > 
> > 
> > On 16/07/14 12:21, Alex Shi wrote:
> >> With ARCH_VEXPRESS_SPC option, kernel build has the following
> >> warning:
> >>
> >> arch/arm/mach-vexpress/spc.c: In function ‘ve_spc_clk_init’:
> >> arch/arm/mach-vexpress/spc.c:431:38: warning: array subscript is below
> >> array bounds [-Warray-bounds]
> >>    struct ve_spc_opp *opps = info->opps[cluster];
> >>                                        ^
> >> since 'cluster' maybe '-1' in UP system. This patch does a active
> >> checking to fix this issue.
> >>
> > 
> > Good catch, looks fine to me.
> > 
> > Acked-by: Sudeep Holla <sudeep.holla@arm.com>
> 
> Anyone like to pick up this build warning fix? Or comments are appreciated!

My fault, sorry, forgot about it...

Acked-by: Pawel Moll <pawel.moll@arm.com>

Arnd, Olof, could you please queue it as a fix? Happy to push a branch
if you wish.

Thanks!

Pawel


