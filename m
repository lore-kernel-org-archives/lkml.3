Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3ETF3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 01:29:45 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:61321 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3ETF3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 01:29:42 -0400
MIME-Version: 1.0
In-Reply-To: <2001452.Fn2HjLbNED@vostro.rjw.lan>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
	<CAKohponkFB7ND38jv5oGnQLx8cq0b=uHTCmL3EERe6P54ijYhw@mail.gmail.com>
	<093901ce509f$afe92f40$0fbb8dc0$%kim@samsung.com>
	<2001452.Fn2HjLbNED@vostro.rjw.lan>
Date: Mon, 20 May 2013 10:59:42 +0530
Message-ID: <CAKohpon97dbLDF0xU7vhf5V+UVeJv7WdeMuZ1jXLUTey2+gD2A@mail.gmail.com>
Subject: Re: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Robin Randhawa <robin.randhawa@arm.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-pm@vger.kernel.org,
        patches@linaro.org, Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steve.Bannister@arm.com,
        arvind.chauhan@arm.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 May 2013 18:30, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, May 14, 2013 09:36:42 PM Kukjin Kim wrote:
>> Viresh Kumar wrote:
>> >
>> > On 13 May 2013 16:21, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > > That doesn't matter I suppose.  I can take it, but please rebase it on
>> > top
>> > > of current linux-next.
>> >
>> > I have already done that (attached). But i wasn't sure what Kukjin wants
>> > as
>> > he may report conflicts again and i will ask the same question for 3.12 :)
>> >
>> Since this missed last time, this would be sent to upstream via samsung tree
>> again. It means the conflicts should be handled by myself.
>>
>> Rafael, if you don't mind, let me take this into Samsung tree for v3.11.
>
> Sure, please go ahead.

Kukjin,

I hope you have already applied this for linux-next?
