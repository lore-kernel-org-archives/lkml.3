Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaFEWjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:39:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51670 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFEWjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:39:12 -0400
Date: Thu, 05 Jun 2014 15:39:11 -0700 (PDT)
Message-Id: <20140605.153911.1518747275654141729.davem@davemloft.net>
To: bergo.torino@gmail.com
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: fix sparse warning in fixed.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401992862-8427-1-git-send-email-bergo.torino@gmail.com>
References: <1401992862-8427-1-git-send-email-bergo.torino@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Jun 2014 15:39:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Zapalowicz <bergo.torino@gmail.com>
Date: Thu,  5 Jun 2014 20:27:42 +0200

> This commit fixes the following sparse warning:
> 
> drivers/net/phy/fixed.c:207
>     - warning: symbol 'fixed_phy_del' was not declared.
>       Should it be static?
> 
> by adding symbol definition to the phy_fixed.h API file. It is ok to do
> because the function in question is an exported symbol.
> 
> Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>

Applied to net-next, thanks.
