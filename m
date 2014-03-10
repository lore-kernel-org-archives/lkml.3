Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaCJUaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:30:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47222 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaCJUaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:30:04 -0400
Date: Mon, 10 Mar 2014 16:30:02 -0400 (EDT)
Message-Id: <20140310.163002.2203078134032583309.davem@davemloft.net>
To: guz.fnst@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: add a pre-check of net_ns in sk_change_net()
From: David Miller <davem@davemloft.net>
In-Reply-To: <531D1C0E.6010507@cn.fujitsu.com>
References: <5319A3C2.8080001@cn.fujitsu.com>
	<20140309.190941.472588800498066811.davem@davemloft.net>
	<531D1C0E.6010507@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 13:30:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Mon, 10 Mar 2014 09:57:34 +0800

> We do not need to switch the net_ns if the target net_ns the same
> as the current one, so here we add a pre-check of net_ns to avoid
> this as David suggested.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Applied to net-next, thank you.
