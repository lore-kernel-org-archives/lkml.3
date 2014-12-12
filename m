Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030493AbaLLQBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:01:15 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35820 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586AbaLLQBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:01:14 -0500
Date: Fri, 12 Dec 2014 11:01:12 -0500 (EST)
Message-Id: <20141212.110112.2111858437852858965.davem@davemloft.net>
To: msalter@redhat.com
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: export fixed_phy_register()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418357006-2450-1-git-send-email-msalter@redhat.com>
References: <1418357006-2450-1-git-send-email-msalter@redhat.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Dec 2014 08:01:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>
Date: Thu, 11 Dec 2014 23:03:26 -0500

> When building the bcmgenet driver as module, I get:
> 
> ERROR: "fixed_phy_register" [drivers/net/ethernet/broadcom/genet/genet.ko] undefined!
> 
> commit b0ba512e225d72 ("net: bcmgenet: enable driver to work without device
> tree") which added a call to fixed_phy_register. But fixed_phy_register
> needs to be exported if used from a module.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

APplied.
