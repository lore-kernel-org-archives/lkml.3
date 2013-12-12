Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3LLSr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:47:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38910 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3LLSrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:47:22 -0500
Date: Thu, 12 Dec 2013 13:47:20 -0500 (EST)
Message-Id: <20131212.134720.844724034413976971.davem@davemloft.net>
To: balbi@ti.com
Cc: mugunthanvnm@ti.com, bigeasy@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers: net: cpsw: fix for cpsw crash when build
 as modules
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386821345-30555-2-git-send-email-balbi@ti.com>
References: <1386821345-30555-1-git-send-email-balbi@ti.com>
	<1386821345-30555-2-git-send-email-balbi@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Dec 2013 10:47:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>
Date: Wed, 11 Dec 2013 22:09:05 -0600

> From: Mugunthan V N <mugunthanvnm@ti.com>
> 
> When CPSW and Davinci MDIO are build as modules, CPSW crashes when
> accessing CPSW registers in CPSW probe. The same is working in built-in
> as the CPSW clocks are enabled in Davindi MDIO probe, SO Enabling the
> clocks before accessing the version register and moving out the other
> register access to cpsw device open.
> 
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

Applied, thanks.
