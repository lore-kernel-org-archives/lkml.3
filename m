Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaH2Bp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 21:45:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45420 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaH2Bp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 21:45:58 -0400
Message-ID: <53FFDB50.3060904@linaro.org>
Date: Fri, 29 Aug 2014 09:45:52 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: Pawel Moll <Pawel.Moll@arm.com>, "nico@linaro.org" <nico@linaro.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mark.brown@linaro.org" <mark.brown@linaro.org>,
        "tixy@linaro.org" <tixy@linaro.org>
Subject: Re: [PATCH] vexpress/spc: fix a build warning on array bounds
References: <1405509716-19591-1-git-send-email-alex.shi@linaro.org> <53C661CB.7040306@arm.com>
In-Reply-To: <53C661CB.7040306@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/16/2014 07:28 PM, Sudeep Holla wrote:
> 
> 
> On 16/07/14 12:21, Alex Shi wrote:
>> With ARCH_VEXPRESS_SPC option, kernel build has the following
>> warning:
>>
>> arch/arm/mach-vexpress/spc.c: In function ‘ve_spc_clk_init’:
>> arch/arm/mach-vexpress/spc.c:431:38: warning: array subscript is below
>> array bounds [-Warray-bounds]
>>    struct ve_spc_opp *opps = info->opps[cluster];
>>                                        ^
>> since 'cluster' maybe '-1' in UP system. This patch does a active
>> checking to fix this issue.
>>
> 
> Good catch, looks fine to me.
> 
> Acked-by: Sudeep Holla <sudeep.holla@arm.com>

Anyone like to pick up this build warning fix? Or comments are appreciated!
