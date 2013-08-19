Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750832Ab3HSEkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:40:09 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:51642 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3HSEkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:40:06 -0400
MIME-Version: 1.0
In-Reply-To: <CADGdYn4frwbpjn94XE_G7pz0D=dcMG8_9zyqUsvKrVtQnphM5Q@mail.gmail.com>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
	<14993d27bdc6a91eced0af5eb96bdb5ca6546cbf.1376619363.git.viresh.kumar@linaro.org>
	<CADGdYn6TKURuO8jxL=tjvSLbmpUoUwoa08MZhsBAiEF91FM-cA@mail.gmail.com>
	<CADGdYn4frwbpjn94XE_G7pz0D=dcMG8_9zyqUsvKrVtQnphM5Q@mail.gmail.com>
Date: Mon, 19 Aug 2013 10:10:05 +0530
Message-ID: <CAKohpon2UZbsZiq4r0r67FwJ+VtzCoM3=naH8qPR-PFaUGbycQ@mail.gmail.com>
Subject: Re: [PATCH 13/34] cpufreq: exynos5440: set CPUFREQ_NO_NOTIFICATION flag
From: Viresh Kumar <viresh.kumar@linaro.org>
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2013 09:12, amit daniel kachhap <amit.daniel@samsung.com> wrote:
>>> +       .flags          = CPUFREQ_STICKY | CPUFREQ_NO_NOTIFICATION,
> How about naming the flag as CPUFREQ_ASYNC_NOTIFICATION? For platforms
> not defining this flag, the notifiers can be called synchronously from
> the core driver.

Nice.. +1

My repo will be updated with this change..
