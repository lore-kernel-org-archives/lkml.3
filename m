Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaIZTRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:17:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50031 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaIZTRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:17:38 -0400
Date: Fri, 26 Sep 2014 15:17:35 -0400 (EDT)
Message-Id: <20140926.151735.307981742214921761.davem@davemloft.net>
To: joe@perches.com
Cc: amirv@mellanox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mellanox: Change en_print to return void
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411407622.2952.49.camel@joe-AO725>
References: <1411407622.2952.49.camel@joe-AO725>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Sep 2014 12:17:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 22 Sep 2014 10:40:22 -0700

> No caller or macro uses the return value so make it void.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> This change is associated to a desire to eventually
> change printk to return void.

Applied, thanks.
