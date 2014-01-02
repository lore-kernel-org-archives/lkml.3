Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaABIbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 03:31:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47570 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaABIba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 03:31:30 -0500
Date: Thu, 02 Jan 2014 03:31:28 -0500 (EST)
Message-Id: <20140102.033128.1126194974741927303.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: geoff@infradead.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/25] net: fix error return code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1388357260-4843-8-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
	<1388357260-4843-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 Jan 2014 00:31:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Sun, 29 Dec 2013 23:47:22 +0100

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Set the return variable to propagate any error code as done elsewhere in
> the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
