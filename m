Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab3IMD16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 23:27:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41718 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab3IMD1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 23:27:54 -0400
Date: Thu, 12 Sep 2013 23:27:44 -0400 (EDT)
Message-Id: <20130912.232744.661366284428853054.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: grundler@parisc-linux.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tulip: remove deprecated IRQF_DISABLED
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378959624-4123-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1378959624-4123-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Sep 2013 20:27:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Thu, 12 Sep 2013 06:20:24 +0200

> This patch proposes to remove the IRQF_DISABLED flag from
> drivers/net/ethernet/dec/tulip/de4x5.c
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied.
