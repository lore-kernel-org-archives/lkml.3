Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810AbaE3XZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 19:25:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60393 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaE3XZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 19:25:53 -0400
Date: Fri, 30 May 2014 16:25:50 -0700 (PDT)
Message-Id: <20140530.162550.1648501676114480780.davem@davemloft.net>
To: benoit.taine@lip6.fr
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 14/18] r8152: Use kmemdup instead of kmalloc + memcpy
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401117687-28911-15-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
	<1401117687-28911-15-git-send-email-benoit.taine@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 May 2014 16:25:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Taine <benoit.taine@lip6.fr>
Date: Mon, 26 May 2014 17:21:23 +0200

> This issue was reported by coccicheck using the semantic patch 
> at scripts/coccinelle/api/memdup.cocci
> 
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
> ---
> Tested by compilation without errors.

Applied to net-next, thank you.
