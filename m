Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3BVB4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:56:51 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35576 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3BVB4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:56:49 -0500
MIME-Version: 1.0
In-Reply-To: <51265BC6.8030601@semaphore.gr>
References: <51253715.7080600@semaphore.gr>
	<CAOh2x=mD4DbEH245xsceS1wyhmrRPpB2LeJ9Mh+WGHUA+bZprA@mail.gmail.com>
	<512605A1.8090106@semaphore.gr>
	<CAOh2x=m82jKMf+xgg+fjnCUHLpCQ_NgYqw4auyAidokt_z=uOw@mail.gmail.com>
	<51265BC6.8030601@semaphore.gr>
Date: Fri, 22 Feb 2013 07:26:48 +0530
Message-ID: <CAKohpokKCrvMYWQCRWccDJHbBNO7km5-vP=d3TwhDyU7HGX-YA@mail.gmail.com>
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 February 2013 23:09, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Thanks again. Following V3 with your suggestion.
>
> Regards,
> Stratos
>
> -----------------------8<--------------------------------------------
> Instead of checking only the absolute value of CPU load_freq to increase
> frequency, we detect forthcoming CPU load rise and increase frequency
> earlier.
>
> Every sampling rate, we calculate the gradient of load_freq. If it is
> too steep we assume that the load most probably will go over
> up_threshold in next iteration(s) and we increase frequency immediately.
>
> New tuners are introduced:
> - early_demand: to enable this functionality (disabled by default).
> - grad_up_threshold: over this gradient of load we will increase
> frequency immediately.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
