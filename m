Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3IMVqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:46:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57228 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab3IMVp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:45:59 -0400
Date: Fri, 13 Sep 2013 17:45:57 -0400 (EDT)
Message-Id: <20130913.174557.622678961981086743.davem@davemloft.net>
To: viresh.kumar@linaro.org
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 054/228] cpufreq: sparc: call
 cpufreq_frequency_table_put_attr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <7baecf8302d921d18afa8fc7447e68e41eb434e8.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<cover.1379063063.git.viresh.kumar@linaro.org>
	<7baecf8302d921d18afa8fc7447e68e41eb434e8.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 13 Sep 2013 14:45:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Fri, 13 Sep 2013 18:30:00 +0530

> Drivers which have an exit path must call cpufreq_frequency_table_put_attr() if
> they have called cpufreq_frequency_table_get_attr() in their init path.
> 
> This driver was missing this part and is fixed with this patch.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: David S. Miller <davem@davemloft.net>
