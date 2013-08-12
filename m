Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3HLE7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 00:59:48 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:42605 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab3HLE7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 00:59:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130811055322.GA28118@localhost>
References: <20130811055322.GA28118@localhost>
Date: Mon, 12 Aug 2013 10:29:45 +0530
X-Google-Sender-Auth: nKsEgM4ldUEApz4fdcy5BS2m9jA
Message-ID: <CAOh2x=nZhUujAKe-NRnfu7GwkPC3U-Po7qpD8xiWHGktF1kXKQ@mail.gmail.com>
Subject: Re: [cpufreq] BUG: unable to handle kernel NULL pointer dereference
 at (null)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 11:23 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> I got the below dmesg and the first bad commit is
>
> commit 01e3e82efc6742d5cf7ba14fb7a9bea318b386d8
> Author: Lukasz Majewski <l.majewski@samsung.com>
> Date:   Tue Aug 6 22:53:08 2013 +0530
>
>     cpufreq: Store cpufreq policies in a list
>
>     Policies available in the cpufreq framework are now linked together.
>     They are accessible via cpufreq_policy_list defined in the cpufreq
>     core.
>
>     Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
>     Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Its already fixed by: c88a1f8b96e7384627b918dfabbfc0c615a4a914 in Rafael's
bleeding-edge branch.. Thanks for reporting.
