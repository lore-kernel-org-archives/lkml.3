Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaFBR7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:59:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35339 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaFBR7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:59:00 -0400
Date: Mon, 02 Jun 2014 10:58:59 -0700 (PDT)
Message-Id: <20140602.105859.1728862913327118150.davem@davemloft.net>
To: benoit.taine@lip6.fr
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] lpc_eth: Use resource_size instead of
 computation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140602113430.GA3823@lip6.fr>
References: <20140601.192705.693805935389177182.davem@davemloft.net>
	<20140602112419.GA3625@lip6.fr>
	<20140602113430.GA3823@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Jun 2014 10:59:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Taine <benoit.taine@lip6.fr>
Date: Mon, 2 Jun 2014 13:34:30 +0200

> This issue was reported by coccicheck using the semantic patch 
> at scripts/coccinelle/api/resource_size.cocci
> 
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

This patch doesn't apply cleanly to any of my trees.
