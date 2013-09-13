Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3IMXbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 19:31:15 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55526 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab3IMXbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 19:31:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] cpufreq: fix transition_ongoing count for powernow-k8
Date: Sat, 14 Sep 2013 01:42:19 +0200
Message-ID: <10372288.T6XyLE5FeS@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <cover.1379062834.git.viresh.kumar@linaro.org>
References: <cover.1379062834.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 13, 2013 06:29:37 PM Viresh Kumar wrote:
> This has been running in my mind since few days... That we have fixed cpufreq
> core and all other drivers for transition serialization but what about
> powernow-k8? It is somewhat special (even more than exynos5440).. It queues a
> work from ->target() and may or maynot send notifications at all..
> 
> Finally I have got a solution now (detailed logs in the patch)..
> These must go with following patchset:

The "must go" here is a totally wrong way of speaking about things, because I'm
not sure I'll take this patch series yet.

> https://lkml.org/lkml/2013/9/12/173

Thanks,
Rafael

