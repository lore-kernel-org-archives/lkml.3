Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392AbaFCXJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:09:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49859 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934243AbaFCXJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:09:16 -0400
Date: Tue, 03 Jun 2014 16:09:15 -0700 (PDT)
Message-Id: <20140603.160915.450521382704524671.davem@davemloft.net>
To: benoit.taine@lip6.fr
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2 v5] lpc_eth: Use resource_size instead of
 computation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140603104559.GA21087@lip6.fr>
References: <20140602113430.GA3823@lip6.fr>
	<20140603103254.GA20794@lip6.fr>
	<20140603104559.GA21087@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Jun 2014 16:09:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Taine <benoit.taine@lip6.fr>
Date: Tue, 3 Jun 2014 12:45:59 +0200

> This issue was reported by coccicheck using the semantic patch 
> at scripts/coccinelle/api/resource_size.cocci
> 
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

Applied, thanks.
