Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab3IKUPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:15:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46855 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab3IKUPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:15:07 -0400
Date: Wed, 11 Sep 2013 16:15:05 -0400 (EDT)
Message-Id: <20130911.161505.542945565529627644.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: jogo@openwrt.org, joe@perches.com, jg1.han@samsung.com, mbizon@freebox.fr,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm63xx_enet: remove deprecated IRQF_DISABLED
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378537010-7128-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1378537010-7128-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Sep 2013 13:15:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Sat,  7 Sep 2013 08:56:50 +0200

> This patch proposes to remove the IRQF_DISABLED flag from
> drivers/net/ethernet/broadcom/bcm63xx_enet.c
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied.
