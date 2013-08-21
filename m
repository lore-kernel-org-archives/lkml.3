Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3HUGur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:50:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52349 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3HUGup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:50:45 -0400
Date: Tue, 20 Aug 2013 23:50:45 -0700 (PDT)
Message-Id: <20130820.235045.928210475401472997.davem@davemloft.net>
To: ujhelyi.m@gmail.com
Cc: mugunthanvnm@ti.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: cpsw: Add support for wake-on-lan for
 cpsw
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376978378-26096-1-git-send-email-ujhelyi.m@gmail.com>
References: <1376978378-26096-1-git-send-email-ujhelyi.m@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 20 Aug 2013 23:50:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ujhelyi.m@gmail.com
Date: Tue, 20 Aug 2013 07:59:38 +0200

> From: Matus Ujhelyi <ujhelyi.m@gmail.com>
> 
> Some phy's can be configured to enable wake on lan (e.g. at803x or marvell 88E1318S).
> There is no way how to enable wol on CPSW with such connected phys. This patch
> adds this support. It is provided by calling the phy's related code.
> 
> Tested on board with at8030x connected phy. Wol interrupt line is
> connected to GPIO0 on am335x.
> 
> Signed-off-by: Matus Ujhelyi <ujhelyi.m@gmail.com>

Applied.
