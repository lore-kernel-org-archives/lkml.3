Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3G2KPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 06:15:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56372 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab3G2KO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 06:14:56 -0400
Message-ID: <51F640AB.2050709@arm.com>
Date: Mon, 29 Jul 2013 11:15:07 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Hanjun Guo <hanjun.guo@linaro.org>,
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
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sudeep.KarkadaNagesha@arm.com
Subject: Re: [RFC][PATCH 1/2] ARM64: add cpu topology definition
References: <1374921728-9007-1-git-send-email-hanjun.guo@linaro.org> <CAKfTPtBpo41LJ3V8TB8YwudwqpURuA2u_Lvu4KYVK=qSs+gFuQ@mail.gmail.com>
In-Reply-To: <CAKfTPtBpo41LJ3V8TB8YwudwqpURuA2u_Lvu4KYVK=qSs+gFuQ@mail.gmail.com>
X-OriginalArrivalTime: 29 Jul 2013 10:14:50.0782 (UTC) FILETIME=[76205BE0:01CE8C44]
X-MC-Unique: 113072911145312901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/13 10:46, Vincent Guittot wrote:
> On 27 July 2013 12:42, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>> Power aware scheduling needs the cpu topology information to improve the
>> cpu scheduler decision making.
> 
> It's not only power aware scheduling. The scheduler already uses
> topology and cache sharing when  CONFIG_SCHED_MC and/or
> CONFIG_SCHED_SMT are enable. So you should also add these configs for
> arm64 so the scheduler can use it
> 
Just for my knowledge, I thought power aware using SCHED_MC/SMT was
removed. I see commit 8e7fbcbc22c12414bcc9dfdd683637f58fb32759 "sched:
Remove stale power aware scheduling remnants and dysfunctional knobs"
I may be missing something here.

Regards,
Sudeep

