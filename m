Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaAWF6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 00:58:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54124 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154AbaAWF6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 00:58:13 -0500
Date: Wed, 22 Jan 2014 21:58:12 -0800 (PST)
Message-Id: <20140122.215812.1717276844524835080.davem@davemloft.net>
To: viresh.kumar@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net/neighbour: queue work on power efficient wq
From: David Miller <davem@davemloft.net>
In-Reply-To: <faa5b965e81fcb4c3261561e58a8ab1194ecf562.1390373223.git.viresh.kumar@linaro.org>
References: <c24546776d8ec32afd1c084dd1d2a72fc96c6519.1390373223.git.viresh.kumar@linaro.org>
	<c24546776d8ec32afd1c084dd1d2a72fc96c6519.1390373223.git.viresh.kumar@linaro.org>
	<faa5b965e81fcb4c3261561e58a8ab1194ecf562.1390373223.git.viresh.kumar@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Wed, 22 Jan 2014 12:23:33 +0530

> Workqueue used in neighbour layer have no real dependency of scheduling these on
> the cpu which scheduled them.
> 
> On a idle system, it is observed that an idle cpu wakes up many times just to
> service this work. It would be better if we can schedule it on a cpu which the
> scheduler believes to be the most appropriate one.
> 
> This patch replaces normal workqueues with power efficient versions. This
> doesn't change existing behavior of code unless CONFIG_WQ_POWER_EFFICIENT is
> enabled.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Applied.
