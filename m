Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499Ab3HNIAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:00:46 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:50263 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab3HNIAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:00:39 -0400
Date: Wed, 14 Aug 2013 10:00:33 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 05/35] cpufreq: at32ap: Covert to light weight
 ->target_index() routine
Message-ID: <20130814080033.GA8540@samfundet.no>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
 <1e8023313384685c4f5488b5249423b066e8c133.1376392602.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e8023313384685c4f5488b5249423b066e8c133.1376392602.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 13 Aug 2013 19:02:18 +0530 or thereabout, Viresh Kumar wrote:
> This patch converts existing .target() to newly defined light weight
> .target_index() routine for this driver.
> 
> CPUFreq core will call cpufreq_frequency_table_target() before calling this
> routine and will pass index to it.
> 
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  drivers/cpufreq/at32ap-cpufreq.c | 23 +++++------------------
>  1 file changed, 5 insertions(+), 18 deletions(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
