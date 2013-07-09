Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3GIGuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 02:50:05 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:33713 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GIGuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 02:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
References: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
Date: Tue, 9 Jul 2013 12:20:02 +0530
Message-ID: <CAKohpokzn4jrO3rr8pjzwd4Xn+0umOK-sMANV2Fj5xn6UhBHVg@mail.gmail.com>
Subject: Re: [PATCH 0/6] cpufreq: Add 'load_table' debugfs file to show
 colleced CPUs load
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 July 2013 14:16, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> Second, previous performance/powersave governor haven't calculated CPUs load
> becuase these governor didn't change CPU frequency according to CPUs load. But,
> load_table debugfs file always should indicate the collected CPUs data regardless
> of the kind of cpufreq governor. So, the patch3/4/5 implement that performance/
> powersave governor will check periodically CPUs load by calling dbs_check_cpu()
> with timer.

I raised a query on how can we call dbs_check_cpu() from
performance/powersave? Also, calling this routine will degrade
performance without any sense. So, I vote not for doing it.
