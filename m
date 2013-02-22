Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3BVCUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:20:03 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:53610 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab3BVCT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:19:59 -0500
MIME-Version: 1.0
In-Reply-To: <6210802.HjCYHcMl5j@vostro.rjw.lan>
References: <cover.1360568193.git.viresh.kumar@linaro.org>
	<3793606.bilcxohA80@vostro.rjw.lan>
	<CAKohpom8HiBEXE54BL72s-nWaeXzSRTrp7=MQKrJcon17T9tXQ@mail.gmail.com>
	<6210802.HjCYHcMl5j@vostro.rjw.lan>
Date: Fri, 22 Feb 2013 07:49:59 +0530
Message-ID: <CAKohpo=tkzFgxpUHaVBH+U8ZQ+vyYFT1c4zrDp8NhRzEPxnouw@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] cpufreq: Add per policy governor-init/exit infrastructure
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2013 07:51, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, February 22, 2013 07:38:12 AM Viresh Kumar wrote:
>> No. These are used atleast for ondemand & conservative.
>
> They will be after the next patch, you mean? :-)

> Well, it appeared so from the next patch ...

Yes :)
