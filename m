Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab3HBJzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:55:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47391 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289Ab3HBJzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:55:12 -0400
Message-ID: <51FB81FB.3060709@arm.com>
Date: Fri, 02 Aug 2013 10:55:07 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 0/3] ARM/ARM64 architected timer updates
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <51FB7CB8.6080103@arm.com> <51FB8081.6040501@linaro.org>
In-Reply-To: <51FB8081.6040501@linaro.org>
X-OriginalArrivalTime: 02 Aug 2013 09:55:07.0982 (UTC) FILETIME=[5EC666E0:01CE8F66]
X-MC-Unique: 113080210551000801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/13 10:48, Daniel Lezcano wrote:
> On 08/02/2013 11:32 AM, Sudeep KarkadaNagesha wrote:
>> Hi Daniel,
>>
>> On 22/07/13 12:21, Sudeep KarkadaNagesha wrote:
>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>
>>> This patch series adds support to configure the rate and enable the event
>>> stream for architected timer. Since the timer control register is reset to
>>> zero on warm boot, CPU PM notifier is added to re-initialse it.
>>>
>> This series is required to support TC2 cpuidle.
>> It will be good if you can review and get this in for v3.12
> 
> So do you want me to take the series through my tree ?
> 
Yes I believe it has to go through your(ARM specific clocksource?) tree,
but currently there's a conflict with another bug fix(that should come
from rmk as -rc fix)
(Commit ab8d46c0 "ARM: 7788/1: elf: fix lpae hwcap feature reporting in
proc/cpuinfo" in rmk -fixes)

Regards,
Sudeep


