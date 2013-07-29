Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3G2K20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 06:28:26 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:60616 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab3G2K2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 06:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <51F640AB.2050709@arm.com>
References: <1374921728-9007-1-git-send-email-hanjun.guo@linaro.org>
	<CAKfTPtBpo41LJ3V8TB8YwudwqpURuA2u_Lvu4KYVK=qSs+gFuQ@mail.gmail.com>
	<51F640AB.2050709@arm.com>
Date: Mon, 29 Jul 2013 12:28:24 +0200
Message-ID: <CAKfTPtDBJUy6smFuACjQNVywQUiQs_iPMFs9T6uCwJOX5f7e8w@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] ARM64: add cpu topology definition
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>, Patch Tracking <patches@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        linaro-acpi <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Naresh Bhat <naresh.bhat@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 July 2013 12:15, Sudeep KarkadaNagesha
<Sudeep.KarkadaNagesha@arm.com> wrote:
> On 29/07/13 10:46, Vincent Guittot wrote:
>> On 27 July 2013 12:42, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>>> Power aware scheduling needs the cpu topology information to improve the
>>> cpu scheduler decision making.
>>
>> It's not only power aware scheduling. The scheduler already uses
>> topology and cache sharing when  CONFIG_SCHED_MC and/or
>> CONFIG_SCHED_SMT are enable. So you should also add these configs for
>> arm64 so the scheduler can use it
>>
> Just for my knowledge, I thought power aware using SCHED_MC/SMT was
> removed. I see commit 8e7fbcbc22c12414bcc9dfdd683637f58fb32759 "sched:
> Remove stale power aware scheduling remnants and dysfunctional knobs"
> I may be missing something here.

It's a common mistake to mixed SCHED_MC and powersaving balance with
SCHED_MC. Only the powersaving policy has been removed but the
SCHED_MC and SCHED_SMT are always in the scheduler and gives perf
improvement on arm 32bits

>
> Regards,
> Sudeep
>
