Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3KGICy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:02:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47563 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3KGICj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:02:39 -0500
Date: Thu, 07 Nov 2013 03:02:37 -0500 (EST)
Message-Id: <20131107.030237.589434363047224407.davem@davemloft.net>
To: duanj.fnst@cn.fujitsu.com
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk, a.zummo@towertech.it,
        airlied@linux.ie, dmitry.torokhov@gmail.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net:drivers/net: replace IS_ERR and PTR_ERR with
 PTR_ERR_OR_ZERO
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383724693-16220-1-git-send-email-duanj.fnst@cn.fujitsu.com>
References: <1383724693-16220-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 07 Nov 2013 00:02:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Date: Wed, 6 Nov 2013 15:58:13 +0800

> This patch fixes coccinelle error regarding usage of IS_ERR and
> PTR_ERR instead of PTR_ERR_OR_ZERO.
> 
> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>

Applied.
