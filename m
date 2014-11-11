Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaKKSbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:31:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60049 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaKKSbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:31:48 -0500
Date: Tue, 11 Nov 2014 13:31:46 -0500 (EST)
Message-Id: <20141111.133146.953251668738222622.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, f.fainelli@gmail.com
Subject: Re: [PATCH net-next] dsa: Use netdev_<level> instead of printk
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415579566.23530.47.camel@perches.com>
References: <1415579566.23530.47.camel@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Nov 2014 10:31:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 09 Nov 2014 16:32:46 -0800

> Neaten and standardize the logging output.
> 
> Other miscellanea:
> 
> o Use pr_notice_once instead of a guard flag.
> o Convert existing pr_<level> uses too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
