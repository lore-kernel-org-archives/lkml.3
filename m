Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaJFEza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 00:55:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39818 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaJFEzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 00:55:25 -0400
MIME-Version: 1.0
In-Reply-To: <54321F90.2010103@nvidia.com>
References: <1412232900-11238-1-git-send-email-vinceh@nvidia.com>
	<CAKohpon=dwc--SSbwjREdrALfXH=7QCw8UJnyVX5x3TCKB=7Bw@mail.gmail.com>
	<54321F90.2010103@nvidia.com>
Date: Mon, 6 Oct 2014 10:25:24 +0530
Message-ID: <CAKohpo=LFLRimA=_PH_OK4XddpphciaZdDEc2dirJifKnL=4Tw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: respect the min/max settings from user space
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vince Hsu <vinceh@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>, dgreid@google.com,
        olofj@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 October 2014 10:20, Vince Hsu <vinceh@nvidia.com> wrote:
> I did test with Chrome kernel on Tegra platform. I can't do that with
> mainline kernel because we haven't had the CPU EDP driver upstream yet.

You should have mentioned this clearly :)

Looks fine to me then.
