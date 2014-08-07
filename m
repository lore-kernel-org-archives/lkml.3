Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbaHGKvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:51:16 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33883 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaHGKvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:51:14 -0400
MIME-Version: 1.0
In-Reply-To: <3141717.0s1tLjazMZ@vostro.rjw.lan>
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
	<1406250448-470-4-git-send-email-skannan@codeaurora.org>
	<3141717.0s1tLjazMZ@vostro.rjw.lan>
Date: Thu, 7 Aug 2014 16:21:13 +0530
Message-ID: <CAKohpo=QrZBmFoWq0hBRBDUbP=AiyTRjnTtJ1R5q_r=dhBO3Og@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Saravana Kannan <skannan@codeaurora.org>,
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

On 1 August 2014 03:26, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> I'm still quite unsure how this is going to work with the real CPU hot-remove
> that makes the entire sysfs cpu directories go away.  Can you please explain
> that?

I have little less knowledge on this kind of hotplugs, can you please enlighten
me with some info about this?

Are we talking about big servers which are actually a combination of multiple
motherboards (with SoC's), and any motherboard can be plugged out at
run time. Obviously a single kernel would be running for all these motherboards.

I don't know if we already support that.. Sorry for my lack of
knowledge on this..

--
viresh
