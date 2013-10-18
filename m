Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3JRRaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:30:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56850 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab3JRRaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:30:24 -0400
Date: Fri, 18 Oct 2013 13:30:22 -0400 (EDT)
Message-Id: <20131018.133022.2019297928668290643.davem@davemloft.net>
To: viresh.kumar@linaro.org
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH V2 Resend 31/34] cpufreq: sparc: Convert to light
 weight ->target_index() routine
From: David Miller <davem@davemloft.net>
In-Reply-To: <f138f2a9b7adeefe0dad222ceda1bea8914a3e6e.1382104515.git.viresh.kumar@linaro.org>
References: <cover.1382104514.git.viresh.kumar@linaro.org>
	<cover.1382104514.git.viresh.kumar@linaro.org>
	<f138f2a9b7adeefe0dad222ceda1bea8914a3e6e.1382104515.git.viresh.kumar@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 18 Oct 2013 10:30:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Fri, 18 Oct 2013 19:29:54 +0530

> This patch converts existing .target() to newly defined light weight
> .target_index() routine for this driver.
> 
> CPUFreq core will call cpufreq_frequency_table_target() before calling this
> routine and will pass index to it.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: David S. Miller <davem@davemloft.net>
