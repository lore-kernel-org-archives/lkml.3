Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3BMSl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:41:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42963 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3BMSl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:41:56 -0500
Date: Wed, 13 Feb 2013 13:41:53 -0500 (EST)
Message-Id: <20130213.134153.631152881474627822.davem@davemloft.net>
To: tipecaml@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        mugunthanvnm@ti.com, zonque@gmail.com, hotforest@gmail.com,
        Julia.Lawall@lip6.fr, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: remove redundant NULL check.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360709550-821-1-git-send-email-tipecaml@gmail.com>
References: <20130212.170650.89534546100043269.davem@davemloft.net>
	<1360709550-821-1-git-send-email-tipecaml@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyril Roelandt <tipecaml@gmail.com>
Date: Tue, 12 Feb 2013 23:52:30 +0100

> cpdma_chan_destroy() on a NULL pointer is a no-op, so the NULL check in
> cpdma_ctlr_destroy() can safely be removed.
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>

Applied, thanks.
