Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab3H0K7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:59:55 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:62355 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3H0K7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:59:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAOLK0pzg5VwDBLbUFU8J8wujxUazPgFC-+C4+Z6AMLYv7KcOtw@mail.gmail.com>
References: <CAKohponkO6oZrvrsUGVK0uUbAM5wse7eHd7udtWkab7y2aatGA@mail.gmail.com>
	<20581731.mdSQ720dHi@vostro.rjw.lan>
	<CAOLK0pzg5VwDBLbUFU8J8wujxUazPgFC-+C4+Z6AMLYv7KcOtw@mail.gmail.com>
Date: Tue, 27 Aug 2013 16:29:52 +0530
Message-ID: <CAKohpo=ZKA6ieg9BrVRCRL+_7uiPfb2tWMO0_VOYx0m=Sv4+xQ@mail.gmail.com>
Subject: Re: [Query] CPUFreq: Why do we need policy->user_policy?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lan Tianyu <lantianyu1986@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 August 2013 20:53, Lan Tianyu <lantianyu1986@gmail.com> wrote:
> So far as I know, it stores some user's config and cpufreq_update_policy()
> bases on the data in the struct to start a new policy. Cpu thermal driver
> （/driver/thermal/cpu_cooling.c）also will its value to update freq policy
> when receive a cpufreq policy adjust notification.

Yeah, but how are these different from policy->min/max/policy/governor?
Why do we need to replicate this information?
