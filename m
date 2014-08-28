Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526AbaH1Fxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 01:53:37 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33415 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934267AbaH1Fxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 01:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <1409209212-18730-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409209212-18730-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Thu, 28 Aug 2014 11:23:35 +0530
X-Google-Sender-Auth: c60aYo0zTrAPcvwG4E6vBTShZ4c
Message-ID: <CAOh2x=mLsGNZGJVDNVh4QvyKKkGZFnHdKktB_YtAHKHxZd=vFw@mail.gmail.com>
Subject: Re: [PATCH 1/3] cpufreq: cpu0: Release clk and regulator in remove function
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 12:30 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:
> This function releases clk and regulator in remove function for clean
> unloading.
>
> CC: Shawn Guo <shawn.guo@linaro.org>
> CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> CC: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/cpufreq/cpufreq-cpu0.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

I already have most of this queued up, have sent V3 and cc'd now. See
if you need anything over that.
