Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435Ab3FSI6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:58:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40817 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933820Ab3FSI6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:58:40 -0400
Message-ID: <51C172B3.5030806@ti.com>
Date: Wed, 19 Jun 2013 14:28:27 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <arvind.chauhan@arm.com>,
        <dave.martin@arm.com>
Subject: Re: [PATCH 03/13] cpufreq: davinci: call CPUFREQ_POSTCHANGE notfier
 in error cases
References: <cover.1371630975.git.viresh.kumar@linaro.org> <6e65891cd3e33c5db94563a387832ae648ef0d8c.1371630975.git.viresh.kumar@linaro.org>
In-Reply-To: <6e65891cd3e33c5db94563a387832ae648ef0d8c.1371630975.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/2013 2:22 PM, Viresh Kumar wrote:
> PRECHANGE and POSTCHANGE notifiers must be called in groups, i.e either both
> should be called or both shouldn't be.
> 
> In case we have started PRECHANGE notifier and found an error, we must call
> POSTCHANGE notifier with freqs.new = freqs.old to guarantee that sequence of
> calling notifiers is complete.
> 
> Davinci driver was taking care of it but frequency isn't restored to freqs.old.
> 
> This patch fixes it.
> 
> Cc: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Looks good to me.

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
