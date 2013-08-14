Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575Ab3HNIyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:54:40 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:58358 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759485Ab3HNIyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:54:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAFgnuDe1VwH2_xyyRN382=gGO8N6QKONKpGkLBGK8Hv2Zh1orA@mail.gmail.com>
References: <1376377766-2594-1-git-send-email-chenxg@marvell.com>
	<CAKohpo=QKPvqUcQVsbbSQdWOOi5L-P2CBFzcfMsobs8uGpLkVw@mail.gmail.com>
	<CAFgnuDes_F7Q5CHbXKC=ndrn9Gr3PJfGj0QvDXA-FuGcq41CHQ@mail.gmail.com>
	<CAKohponD2LdDsJy=UJCf-1yANjyPjmAyokV5a4HOSJn_DMJVhA@mail.gmail.com>
	<CAFgnuDetTVYayBABNPhME15b+b6qUtJX2hBaJ6y4+gOSgGFwdQ@mail.gmail.com>
	<CAKohpoksGB6bBtFF4DaqqLME2kpDve5uMycZDCXahaigdRhwKQ@mail.gmail.com>
	<CAFgnuDe1VwH2_xyyRN382=gGO8N6QKONKpGkLBGK8Hv2Zh1orA@mail.gmail.com>
Date: Wed, 14 Aug 2013 14:24:36 +0530
Message-ID: <CAKohpokTA8iUbC8Jhd9Lqd4VbVqiEn-Ntu4jPvYHkbM1MbVM=A@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Add governor operation ongoing flag
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: Xiaoguang Chen <chenxg@marvell.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 August 2013 14:20, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
> Hi, Viresh
> After checking your patch, I find that __cpufreq_set_policy function
> doesn't check STOP and EXIT 's return value
> is it on purpose? if not, I can provide a patch to add it.

I thought we probably can't break on these calls here, while we are trying to
stop existing governor. And so didn't check return values..

If you face some issues with them, you are free to add checks.
