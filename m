Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3IPE4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 00:56:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58518 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3IPE4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 00:56:09 -0400
Date: Mon, 16 Sep 2013 00:56:08 -0400 (EDT)
Message-Id: <20130916.005608.2063539787734475811.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: geoff@infradead.org, netdev@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ps3_gelic: remove deprecated IRQF_DISABLED
From: David Miller <davem@davemloft.net>
In-Reply-To: <1379046798-7192-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1379046798-7192-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 15 Sep 2013 21:56:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Fri, 13 Sep 2013 06:33:18 +0200

> This patch proposes to remove the IRQF_DISABLED flag from
> drivers/net/ethernet/toshiba/ps3_gelic_net.c
> 
> It's a NOOP since 2.6.35 and I will remove it one day ;)
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied.
