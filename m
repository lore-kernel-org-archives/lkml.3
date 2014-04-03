Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaDCSDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:03:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45910 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaDCSDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:03:30 -0400
Date: Thu, 03 Apr 2014 14:05:03 -0400 (EDT)
Message-Id: <20140403.140503.968514828017455803.davem@davemloft.net>
To: jwboyer@gmail.com
Cc: benve@cisco.com, ssujith@cisco.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: enic: include irq.h for irqreturn_t definitions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140402152400.GC20438@zod>
References: <20140402152400.GC20438@zod>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Apr 2014 11:03:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@gmail.com>
Date: Wed, 2 Apr 2014 11:24:00 -0400

> The enic driver fails to build on ARM with:
> 
> In file included from drivers/net/ethernet/cisco/enic/enic_res.c:40:0:
> drivers/net/ethernet/cisco/enic/enic.h:48:2: error: expected specifier-qualifier-list before 'irqreturn_t'
>   irqreturn_t (*isr)(int, void *);
>   ^
> 
> Nothing in the driver is explicitly including the irq definitions, so we add
> an include of linux/irq.h to pick them up.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

Applied.
