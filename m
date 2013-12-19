Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3LSULM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:11:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35649 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab3LSULL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:11:11 -0500
Date: Thu, 19 Dec 2013 15:11:09 -0500 (EST)
Message-Id: <20131219.151109.331529110864072765.davem@davemloft.net>
To: k.lewandowsk@samsung.com
Cc: netdev@vger.kernel.org, kyungmin.park@samsung.com, lennart@poettering.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Make it possible to set defaults for
 net.core.[rw]mem_max parameters
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387272353-3560-1-git-send-email-k.lewandowsk@samsung.com>
References: <1387272353-3560-1-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 12:11:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karol Lewandowski <k.lewandowsk@samsung.com>
Date: Tue, 17 Dec 2013 10:25:53 +0100

> Default limits are quite low even for today's embedded hardware.
> 
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>

You can up the default, but adding a Kconfig option is not necessary.
People can add knobs to /etc/sysctl.conf if they want, that's what
it is there fore.
