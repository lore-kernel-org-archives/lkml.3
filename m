Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3C0D2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:28:40 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:32785 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3C0D2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <1473108.YvH7sY4Gsu@vostro.rjw.lan>
References: <225d20676ec96aa81683f23485f0339e32a22917.1364308732.git.viresh.kumar@linaro.org>
	<1473108.YvH7sY4Gsu@vostro.rjw.lan>
Date: Wed, 27 Mar 2013 08:58:38 +0530
Message-ID: <CAKohpom9J4i=FYauNjrUqX8195hw6AwHO0zfaECKxA2Ew=Ugbw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: cpu0: Fix mistake in Documentation example
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: shawn.guo@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2013 04:20, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, March 26, 2013 08:10:46 PM Viresh Kumar wrote:
>> "clock-latency" is incorrectly written as "transition-latency" in an example
>> present in Documentation of cpufreq-cpu0. Fix it.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Am I supposed to take this?

Yes.
