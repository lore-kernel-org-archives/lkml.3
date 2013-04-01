Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab3DAQ6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:58:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57366 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114Ab3DAQ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:58:33 -0400
Date: Mon, 01 Apr 2013 12:58:30 -0400 (EDT)
Message-Id: <20130401.125830.1655034418750471341.davem@davemloft.net>
To: viresh.kumar@linaro.org
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org, lethal@linux-sh.org,
        trenn@suse.de, bp@alien8.de, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 6/9] cpufreq: Don't check if cpu is online/offline for
 cpufreq callbacks
From: David Miller <davem@davemloft.net>
In-Reply-To: <cd771cb37feb4e79172548ed342ad194ee31a384.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
	<cover.1364820620.git.viresh.kumar@linaro.org>
	<cd771cb37feb4e79172548ed342ad194ee31a384.1364820620.git.viresh.kumar@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 01 Apr 2013 09:58:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon,  1 Apr 2013 18:27:46 +0530

> cpufreq layer doesn't call cpufreq driver's callback for any offline cpu and so
> checking that isn't useful.
> 
> Lets get rid of it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

For sparc bits:

Acked-by: David S. Miller <davem@davemloft.net>
