Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbbAYIXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 03:23:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60742 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbbAYIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 03:23:45 -0500
Date: Sun, 25 Jan 2015 00:23:44 -0800 (PST)
Message-Id: <20150125.002344.882303502800355463.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: llc: use correct size for sysctl timeout entries
From: David Miller <davem@davemloft.net>
In-Reply-To: <1422064020-22080-1-git-send-email-sasha.levin@oracle.com>
References: <1422064020-22080-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Jan 2015 00:23:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Fri, 23 Jan 2015 20:47:00 -0500

> The timeout entries are sizeof(int) rather than sizeof(long), which
> means that when they were getting read we'd also leak kernel memory
> to userspace along with the timeout values.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Applied, thank you.
