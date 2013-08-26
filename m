Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3HZHMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:12:33 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:59810 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3HZHMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:12:31 -0400
Date: Mon, 26 Aug 2013 09:12:25 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/16] cpufreq: at32ap: use cpufreq_generic_get() routine
Message-ID: <20130826071225.GA6501@samfundet.no>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
 <25c1ed14adc7fff2b2fbac993c829997fc7eea12.1377272740.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25c1ed14adc7fff2b2fbac993c829997fc7eea12.1377272740.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Fri 23 Aug 2013 21:20:38 +0530 or thereabout, Viresh Kumar wrote:
> We have common infrastructure available with us for getting a CPUs clk rate.
> Lets use it for this driver.
> 
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  drivers/cpufreq/at32ap-cpufreq.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
