Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaDCSDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:03:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45915 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaDCSDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:03:40 -0400
Date: Thu, 03 Apr 2014 14:05:13 -0400 (EDT)
Message-Id: <20140403.140513.2264055788689960268.davem@davemloft.net>
To: jwboyer@fedoraproject.org
Cc: himanshu.madhani@qlogic.com, rajesh.borundia@qlogic.com,
        shahed.shaikh@qlogic.com, linux-driver@qlogic.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qlcnic: include irq.h for irq definitions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140402152547.GD20438@zod>
References: <20140402152547.GD20438@zod>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Apr 2014 11:03:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@fedoraproject.org>
Date: Wed, 2 Apr 2014 11:25:47 -0400

> The qlcnic driver fails to build on ARM with errors like:
> 
> In file included from drivers/net/ethernet/qlogic/qlcnic/qlcnic.h:36:0,
>                  from drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c:8:
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h:585:1: error: unknown type name 'irqreturn_t'
>  irqreturn_t qlcnic_83xx_clear_legacy_intr(struct qlcnic_adapter *);
>  ^
> 
> Nothing in the driver is explicitly including the irq definitions, so we
> add an include of linux/irq.h to pick them up.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

Applied, thanks Josh.
