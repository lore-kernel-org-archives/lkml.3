Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbbAAATw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 19:19:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47784 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbAAATv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 19:19:51 -0500
Date: Wed, 31 Dec 2014 19:19:48 -0500 (EST)
Message-Id: <20141231.191948.2052520407791755413.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: anirudh@xilinx.com, kernel-janitors@vger.kernel.org, John.Linn@xilinx.com,
        michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] net: axienet: fix error return code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419872683-32709-8-git-send-email-Julia.Lawall@lip6.fr>
References: <1419872683-32709-1-git-send-email-Julia.Lawall@lip6.fr>
	<1419872683-32709-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Dec 2014 16:19:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Mon, 29 Dec 2014 18:04:42 +0100

> Return a negative error code on failure.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
