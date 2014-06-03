Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbaFCAuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:50:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38209 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaFCAuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:50:12 -0400
Date: Mon, 02 Jun 2014 17:50:09 -0700 (PDT)
Message-Id: <20140602.175009.223327851419748409.davem@davemloft.net>
To: chianglungyu@gmail.com
Cc: ast@plumgrid.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: filter: fix possible memory leak in
 __sk_prepare_filter()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401601045-7829-1-git-send-email-chianglungyu@gmail.com>
References: <1401601045-7829-1-git-send-email-chianglungyu@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Jun 2014 17:50:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leon Yu <chianglungyu@gmail.com>
Date: Sun,  1 Jun 2014 05:37:25 +0000

> __sk_prepare_filter() was reworked in commit bd4cf0ed3 (net: filter:
> rework/optimize internal BPF interpreter's instruction set) so that it should
> have uncharged memory once things went wrong. However that work isn't complete.
> Error is handled only in __sk_migrate_filter() while memory can still leak in
> the error path right after sk_chk_filter().
> 
> Signed-off-by: Leon Yu <chianglungyu@gmail.com>

Applied, thanks.
