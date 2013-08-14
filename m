Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab3HNOfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:35:43 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:36000 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab3HNOfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:35:41 -0400
Date: Wed, 14 Aug 2013 16:35:35 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/37] cpufreq: at32ap: don't initialize part of policy
 that is set by core too
Message-ID: <20130814143535.GB3263@samfundet.no>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
 <6fe9b31a6e199052e0a91b38c8f6d110e9f57b28.1376486713.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fe9b31a6e199052e0a91b38c8f6d110e9f57b28.1376486713.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 14 Aug 2013 19:01:53 +0530 or thereabout, Viresh Kumar wrote:
> Many common initializations of struct policy are moved to core now and hence
> this driver doesn't need to do it. This patch removes such code.
> 
> Most recent of those changes is to call ->get() in the core after calling
> ->init().

It would be easier to review if you add me to CC on the new APIs you
implement as well. Now I had to look up what the ->get() call did.

> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/at32ap-cpufreq.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Assuming the core get() call replaces the content:

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

-- 
mvh
Hans-Christian Egtvedt
