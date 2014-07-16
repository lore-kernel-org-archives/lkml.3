Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965457AbaGPP2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:28:20 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:36690 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965438AbaGPP2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:28:16 -0400
MIME-Version: 1.0
In-Reply-To: <53C68C54.3010900@gmail.com>
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>
	<1405464473-3916-2-git-send-email-skannan@codeaurora.org>
	<53C68C54.3010900@gmail.com>
Date: Wed, 16 Jul 2014 20:58:15 +0530
Message-ID: <CAKohpokLzMbzr4kdL6wCL7MZgnVe0CQhbJHKL5wWeETH1YwEOg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2014 19:59, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> stop_cpu() only needs to be called during __cpufreq_remove_dev_prepare() no
> where else.

Oh, thanks for reminding us..

Look at this Saravana:
367dc4a cpufreq: Add stop CPU callback to cpufreq_driver interface
