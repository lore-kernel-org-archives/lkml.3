Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaKWTaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:30:20 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35246 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaKWTaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:30:18 -0500
Date: Sun, 23 Nov 2014 14:30:16 -0500 (EST)
Message-Id: <20141123.143016.2013887575160072697.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: chas@cmf.nrl.navy.mil, kernel-janitors@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] solos-pci: fix error return code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416667159-9808-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1416667159-9808-1-git-send-email-Julia.Lawall@lip6.fr>
	<1416667159-9808-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Nov 2014 11:30:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Sat, 22 Nov 2014 15:39:17 +0100

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Return a negative error code on failure.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied, thanks Julia.
