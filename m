Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaADA7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:59:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35504 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaADA7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:59:14 -0500
Date: Fri, 03 Jan 2014 19:59:13 -0500 (EST)
Message-Id: <20140103.195913.1578018150201921315.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: steve.glendinning@shawell.net, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] smsc9420: use named constants for pci_power_t
 values
From: David Miller <davem@davemloft.net>
In-Reply-To: <1388706031-22180-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1388706031-22180-1-git-send-email-Julia.Lawall@lip6.fr>
	<1388706031-22180-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 03 Jan 2014 16:59:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Fri,  3 Jan 2014 00:40:31 +0100

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied, thanks Julia.
