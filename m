Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3CQQnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 12:43:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46226 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab3CQQnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 12:43:12 -0400
Date: Sun, 17 Mar 2013 12:43:10 -0400 (EDT)
Message-Id: <20130317.124310.989927335904954119.davem@davemloft.net>
To: laijs@cn.fujitsu.com
Cc: paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, amwang@redhat.com, nhorman@tuxdriver.com,
        edumazet@google.com, jiri@resnulli.us, netdev@vger.kernel.org
Subject: Re: [PATCH 4/9] netpoll: use DEFINE_STATIC_SRCU() to define
 netpoll_srcu
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363366257-4886-5-git-send-email-laijs@cn.fujitsu.com>
References: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
	<1363366257-4886-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 17 Mar 2013 09:43:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Sat, 16 Mar 2013 00:50:52 +0800

> DEFINE_STATIC_SRCU() defines srcu struct and do init at build time.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied.
