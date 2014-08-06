Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaHFFIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 01:08:39 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:53771 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaHFFIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 01:08:37 -0400
MIME-Version: 1.0
In-Reply-To: <5600331.UfWMPf73u1@vostro.rjw.lan>
References: <1407183283-21921-1-git-send-email-moon.linux@yahoo.com>
	<CAKohpo=j59=5fmVAdhGXkdb3YHN6zDQBkibZZTfc73GvSqx=3A@mail.gmail.com>
	<5600331.UfWMPf73u1@vostro.rjw.lan>
Date: Wed, 6 Aug 2014 10:38:37 +0530
Message-ID: <CAKohpo=VQEtmSLE5-fQ8=zb-kkRYN8kZeaBPzMV5rF=WxxmeDg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq_opp.c: Fixed the __might_sleep by changing
 GFP_KERNEL to GFP_ATOMIC.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Anand Moon <moon.linux@yahoo.com>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 August 2014 05:05, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> https://lkml.org/lkml/2014/7/16/815
>>
>> @Rafael: Have you already applied patch from above link?
>
> No, I haven't.  Do we need it after all?

I think yes, Right Stephen? :)
