Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab3HNJRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:17:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38672 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab3HNJRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:17:37 -0400
Message-ID: <520B4B2E.1040700@arm.com>
Date: Wed, 14 Aug 2013 10:17:34 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 0/6] ARM/ARM64 architected timer updates
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <520B490A.4090109@linaro.org>
In-Reply-To: <520B490A.4090109@linaro.org>
X-OriginalArrivalTime: 14 Aug 2013 09:17:32.0745 (UTC) FILETIME=[1B818B90:01CE98CF]
X-MC-Unique: 113081410173501601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/08/13 10:08, Daniel Lezcano wrote:
> On 08/13/2013 07:29 PM, Sudeep KarkadaNagesha wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> This patch series adds support to configure the rate and enable the
>> event stream for architected timer. The event streams can be used to
>> impose a timeout on a WFE, to safeguard against any programming error
>> in case an expected event is not generated or even to implement
>> wfe-based timeouts for userspace locking implementations.
>>
>> Since the timer control register is reset to zero on warm boot, CPU
>> PM notifier is added to re-initialize it.
> 
> It does not apply to my tree.
> 
> Against which tree is this patchset ? Who is supposed to take it ?
> 
As I had mentioned in previous version, because of the conflict, I had
to rebase it on 3.11-rc4

>> Changes v2->v3:
>> 1. Moved ARM and ARM64 changes into separate patches
>> 2. Added native hwcaps definations(ARM/ARM64) and compat-specific
>>    definitions(ARM64) to the users for the event stream feature. 
> 
> Ok, we have the choice:
>  1. split the patchset into arch/arm changes and drivers/clocksource
>  2. I ack the patchset and Olof/Kevin take it
>  3. Olof/Kevin ack the patchset and I take it in my tree.
> 
> This is really becoming fuzzy.
>
I am not sure if we need to split it. It would get too messy because of
dependencies. Once we have ACKs from all the corresponding maintainers,
it can go through one of the tree.

> If you want a maintainer to take a patchset you have to send an email
> --to him and --cc mailing list and others concerned by the patchset.
> 
Ok understood.

Regards,
Sudeep

