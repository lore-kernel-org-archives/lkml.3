Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbbALCoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 21:44:21 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43065 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbbALCoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 21:44:19 -0500
Date: Sun, 11 Jan 2015 21:44:14 -0500 (EST)
Message-Id: <20150111.214414.1072231038443972770.davem@davemloft.net>
To: zhang.chunyan@linaro.org
Cc: samuel@sortiz.org, arnd@arndb.de, zhang.lyra@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] irda: Use ktime_t instead of timeval
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420689692-8760-1-git-send-email-zhang.chunyan@linaro.org>
References: <driver-irda-v2>
	<1420689692-8760-1-git-send-email-zhang.chunyan@linaro.org>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Jan 2015 18:44:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chunyan Zhang <zhang.chunyan@linaro.org>
Date: Thu,  8 Jan 2015 12:01:26 +0800

> This patch-set removed all uses of timeval and used ktime_t instead if
> needed, since 32-bit time types will break in the year 2038.
> 
> This patch-set also used the ktime_xxx functions accordingly.
> e.g.
> * Used ktime_get to get the current time instead of do_gettimeofday.
> * And, used ktime_us_delta to get the elapsed time directly.

Applied to net-next, thanks.
