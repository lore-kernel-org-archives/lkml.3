Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3BKEQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 23:16:06 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:35342 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3BKEQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 23:16:03 -0500
MIME-Version: 1.0
In-Reply-To: <51180DA7.8040203@gmail.com>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
	<b16436f3b3eba648500a287d552efbbf48bcc9bb.1359976493.git.viresh.kumar@linaro.org>
	<51180DA7.8040203@gmail.com>
Date: Mon, 11 Feb 2013 09:46:01 +0530
Message-ID: <CAKohpo=Rk-P_yhvu8WHmpy7UcYqhg4-Y0ragqNMBXgJAB_w4mQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] cpufreq: governor: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: rjw@sisk.pl, Steve.Bannister@arm.com, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2013 02:44, Francesco Lavra <francescolavra.fl@gmail.com> wrote:
> dbs_data->tuners is never freed, which means there is a memory leak
> across CPUFREQ_GOV_POLICY_INIT and CPUFREQ_GOV_POLICY_EXIT events.
>
> The same goes for the ondemand governor.

Thanks for pointing out. Would be fixed in next version.
