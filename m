Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaCCA3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:29:15 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:37397 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaCCA3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:29:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpomqu22Pt5_wYV3u2uC36AgfmrkvxLtJCGakdodEQFE-jQ@mail.gmail.com>
References: <1393432706-25708-1-git-send-email-rashika.kheria@gmail.com>
	<20140226164142.GA18079@thin>
	<CAMpEsFFjR2e_kDn9-QuKcS3RjsSmru9XGjXqXXdO7sYeWdh9dw@mail.gmail.com>
	<20140226170847.GA18427@thin>
	<CAKohpomqu22Pt5_wYV3u2uC36AgfmrkvxLtJCGakdodEQFE-jQ@mail.gmail.com>
Date: Mon, 3 Mar 2014 05:59:13 +0530
Message-ID: <CAKohpont=VTHJdUz4UFtrZtRnkFfUGRrnq3zgvm5sW6ukTRLiQ@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: cpufreq: Mark function as static in cpufreq.c
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: josh@joshtriplett.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2014 10:55, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hi Rashika,
>
> On 26 February 2014 22:08, Rashika Kheria <rashika.kheria@gmail.com> wrote:
>> Mark function as static in cpufreq.c because it is not
>> used outside this file.
>>
>> This eliminates the following warning in cpufreq.c:
>> drivers/cpufreq/cpufreq.c:355:9: warning: no previous prototype for 'show_boost' [-Wmissing-prototypes]
>
> Can you please elaborate how this warning is related to
> the non-static definition of this function?

Ping!!
