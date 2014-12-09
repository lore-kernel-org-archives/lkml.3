Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaLIUYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:24:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38349 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaLIUYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:24:52 -0500
Date: Tue, 09 Dec 2014 15:24:50 -0500 (EST)
Message-Id: <20141209.152450.1137322945046835090.davem@davemloft.net>
To: guz.fnst@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] net/socket.c : introduce helper function
 do_sock_sendmsg to replace reduplicate code
From: David Miller <davem@davemloft.net>
In-Reply-To: <54815B4F.50408@cn.fujitsu.com>
References: <1416799125-13972-1-git-send-email-guz.fnst@cn.fujitsu.com>
	<54815B4F.50408@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 12:24:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Fri, 5 Dec 2014 15:14:23 +0800

> Introduce helper function do_sock_sendmsg() to simplify sock_sendmsg{_nosec},
> and replace reduplicate code.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Applied, thanks.
