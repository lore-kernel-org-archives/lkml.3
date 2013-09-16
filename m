Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab3IPEzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 00:55:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58488 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab3IPEzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 00:55:32 -0400
Date: Mon, 16 Sep 2013 00:55:31 -0400 (EDT)
Message-Id: <20130916.005531.1601939849006549452.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: lantiq_etop: remove deprecated IRQF_DISABLED
From: David Miller <davem@davemloft.net>
In-Reply-To: <1379044782-6542-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1379044782-6542-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 15 Sep 2013 21:55:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Fri, 13 Sep 2013 05:59:42 +0200

> This patch proposes to remove the IRQF_DISABLED flag from
> drivers/net/ethernet/lantiq_etop.c
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied.
