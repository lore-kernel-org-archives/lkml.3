Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3H3Pp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:45:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60259 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3H3Ppz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:45:55 -0400
Message-ID: <5220BE49.2030409@arm.com>
Date: Fri, 30 Aug 2013 16:46:17 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v6 0/5] ARM/ARM64 architected timer updates
References: <1377788142-21388-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <52206EE0.5020907@arm.com> <20130830114309.GW6617@n2100.arm.linux.org.uk> <20130830140406.GE12160@mudshark.cambridge.arm.com>
In-Reply-To: <20130830140406.GE12160@mudshark.cambridge.arm.com>
X-OriginalArrivalTime: 30 Aug 2013 15:45:52.0839 (UTC) FILETIME=[020DBD70:01CEA598]
X-MC-Unique: 113083016455300501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/13 15:04, Will Deacon wrote:
> On Fri, Aug 30, 2013 at 12:43:09PM +0100, Russell King - ARM Linux wrote:
>> On Fri, Aug 30, 2013 at 11:07:28AM +0100, Sudeep KarkadaNagesha wrote:
>>> On 29/08/13 15:55, Sudeep KarkadaNagesha wrote:
>>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>>
>>>> This patch series adds support to configure the rate and enable the
>>>> event stream for architected timer. The event streams can be used to
>>>> impose a timeout on a wfe, to safeguard against any programming error
>>>> in case an expected event is not generated or even to implement
>>>> wfe-based timeouts for userspace locking implementations. This feature
>>>> can be disabled(enabled by default).
>>>>
>>>> Since the timer control register is reset to zero on warm boot, CPU
>>>> PM notifier is added to save and restore the value.
>>>>
>>> Hi Russell,
>>>
>>> Can you have a look at this series ?
>>> If you are OK, can I have your ACK on arm specific changes(PATCH 2/5) ?
>>
>> I think it would be more value to have someone from ARM Ltd ack it,
>> because they will know the code much better than I do.
> 
> Looks good to me, so for patch 2/5:
> 
>   Acked-by: Will Deacon <will.deacon@arm.com>
> 
Thanks Will and Russell.

Hi Catalin,

Can I have your ACK for ARM64 changes(PATCH 3/5) so that Daniel can
accept my pull request ?

Regards,
Sudeep

