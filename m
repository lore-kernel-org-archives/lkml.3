Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3I2V7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 17:59:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49531 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3I2V7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 17:59:41 -0400
Date: Sun, 29 Sep 2013 17:59:36 -0400 (EDT)
Message-Id: <20130929.175936.607666065014569193.davem@davemloft.net>
To: vincent.mc.li@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ipv4:PATCH] Allow userspace to specify primary or secondary
 ip on interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380056988-6717-1-git-send-email-vincent.mc.li@gmail.com>
References: <1380056988-6717-1-git-send-email-vincent.mc.li@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 29 Sep 2013 14:59:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Li <vincent.mc.li@gmail.com>
Date: Tue, 24 Sep 2013 14:09:48 -0700

> the reason for this patch is that we have a multi blade cluster platform 
> sharing 'floating management ip' and also that each blade has its own 
> management ip on the management interface, so whichever blade in the
> cluster becomes primary blade, the 'floating mangaement ip' follows it,
> and we want any of our traffic originated from the primary blade source from
> the 'floating management ip' for consistency. but in this case, since the local
> blade management ip is always the primary ip on the mangaement interface and 
> 'floating management ip' is always secondary, kernel always choose the primary
> ip as source ip address. thus we would like to add the flexibility in kernel to
> allow us to specify which ip to be primary or secondary.

You have the flexibility already.

You can specify a specific source address ot use in routes.
