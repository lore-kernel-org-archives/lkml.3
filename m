Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaDCSD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:03:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45905 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaDCSDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:03:22 -0400
Date: Thu, 03 Apr 2014 14:04:55 -0400 (EDT)
Message-Id: <20140403.140455.585675998546647028.davem@davemloft.net>
To: jwboyer@fedoraproject.org
Cc: ariele@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bnx2x: include irq.h for irqreturn_t definitions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140402152158.GB20438@zod>
References: <20140402152158.GB20438@zod>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Apr 2014 11:03:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@fedoraproject.org>
Date: Wed, 2 Apr 2014 11:21:58 -0400

> The bnx2x driver fails to build on ARM with:
> 
> In file included from drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c:28:0:
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h:243:1: error: unknown type name 'irqreturn_t'
>  irqreturn_t bnx2x_msix_sp_int(int irq, void *dev_instance);
>  ^
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h:251:1: error: unknown type name 'irqreturn_t'
>  irqreturn_t bnx2x_interrupt(int irq, void *dev_instance);
>  ^
> 
> Nothing in bnx2x_link.c or bnx2x_cmn.h is explicitly including the irq
> definitions, so we add an include of linux/irq.h to pick them up.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

Applied.
