Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaDPELe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:11:34 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:32903 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPELc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:11:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1404152031440.22697@ionos.tec.linutronix.de>
References: <cover.1397537986.git.viresh.kumar@linaro.org>
	<486a02efe0246635aaba786e24b42d316438bf3b.1397537987.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1404152031440.22697@ionos.tec.linutronix.de>
Date: Wed, 16 Apr 2014 09:41:32 +0530
Message-ID: <CAKohpok8bLoaC8oo2x_f0cGYCc51Fvnp3Thh0a95BSExvXHDHA@mail.gmail.com>
Subject: Re: [PATCH V1 Resend 1/5] tick-common: fix wrong check in tick_check_replacement()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 April 2014 00:12, Thomas Gleixner <tglx@linutronix.de> wrote:
> B1;3202;0c

What does this mean ??

> On Tue, 15 Apr 2014, Viresh Kumar wrote:
>
>> tick_check_replacement() returns if a replacement of clock_event_device is
>> possible or not. It does this as the first check:
>>
>>       if (tick_check_percpu(curdev, newdev, smp_processor_id()))
>>               return false;
>>
>> This looks wrong as we are returning false when tick_check_percpu() returned
>> true. Probably Thomas forgot '!' here in his commit: 03e13cf5e ?
>
> Come on. You can do better changelogs.

:(

> "This looks wrong" is definitely not a good description of the
> problem.
>
> Either you know WHY it is wrong, then you say so. If not, then you can
> send an RFC.
>
> I fixed the changelog up this time.

Thanks, will take care of such stuff in future.
