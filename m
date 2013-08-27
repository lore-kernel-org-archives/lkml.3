Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3H0F55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 01:57:57 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:48575 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3H0F5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 01:57:55 -0400
MIME-Version: 1.0
In-Reply-To: <521BA068.8030003@semaphore.gr>
References: <521BA068.8030003@semaphore.gr>
Date: Tue, 27 Aug 2013 11:27:54 +0530
Message-ID: <CAKohpo=xBmpEv=oN1qEnq9RKhfjtc4wZayVYyVzjWOU8BnwVJQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governors: Remove duplicate check of target freq
 in supported range
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 August 2013 00:07, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>  drivers/cpufreq/cpufreq_conservative.c | 4 ----

Get rid of few more checks..

/* if we are already at full speed then break out early */
if (dbs_info->requested_freq == policy->max)
return;


/*
* if we cannot reduce the frequency anymore, break out early
*/
if (policy->cur == policy->min)
return;
