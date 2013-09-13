Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab3IMVsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:48:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57273 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3IMVsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:48:54 -0400
Date: Fri, 13 Sep 2013 17:48:53 -0400 (EDT)
Message-Id: <20130913.174853.1422103778851204276.davem@davemloft.net>
To: gamerh2o@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Trivial] remove unnecessary header file inclusion
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130913145718.GA2536@will>
References: <20130913145718.GA2536@will>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 13 Sep 2013 14:48:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ZHAO Gang <gamerh2o@gmail.com>
Date: Fri, 13 Sep 2013 22:57:18 +0800

> 
> file linux/fib_rules.h doesn't exist, so remove it.

Oh yes it does.
