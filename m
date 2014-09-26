Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaIZTRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:17:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50036 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbaIZTRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:17:47 -0400
Date: Fri, 26 Sep 2014 15:17:44 -0400 (EDT)
Message-Id: <20140926.151744.2073645799506529842.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: Change netdev_<level> logging functions
 to return void
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411409450.2952.55.camel@joe-AO725>
References: <1411409450.2952.55.camel@joe-AO725>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Sep 2014 12:17:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 22 Sep 2014 11:10:50 -0700

> No caller or macro uses the return value so make all
> the functions return void.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> This change is associated to a desire to eventually
> change printk to return void.

Also applied, thanks Joe.
