Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaEBTTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:19:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36795 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaEBTTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:19:31 -0400
Date: Fri, 02 May 2014 15:19:27 -0400 (EDT)
Message-Id: <20140502.151927.359156056899842119.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: jim.epost@gmail.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        devel@linuxdriverproject.org, netdev@vger.kernel.org
Subject: Re: randconfig build error with next-20140502, in
 drivers/net/hyperv/netvsc_drv.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <91a4eac99889460f91f619385208cbca@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <CA+r1ZhhAdRwEFE3u4E1QQiCSa6Cz5Onhy1iVJHhzB4dUiEOL4g@mail.gmail.com>
	<91a4eac99889460f91f619385208cbca@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 May 2014 12:19:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri, 2 May 2014 14:42:06 +0000

> real_num_rx_queues is defined in "include/linux/netdevice.h":
> It requires CONFIG_SYSFS flag, which is enabled by default, but not set in 
> your config file.
> 
> Could you use default config and add hyperv drivers, then try again?

You must fix your driver to compile successfully under all possible
configuration combinations, not just the ones which are convenient
for you to support.
