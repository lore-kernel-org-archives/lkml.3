Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaLOQvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:51:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43670 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaLOQvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:51:11 -0500
Date: Mon, 15 Dec 2014 11:51:08 -0500 (EST)
Message-Id: <20141215.115108.1859320509548372496.davem@davemloft.net>
To: cyrille.pitchen@atmel.com
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, soren.brinkmann@xilinx.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] net/macb: fix multiqueue support patch up
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1418651689.git.cyrille.pitchen@atmel.com>
References: <cover.1418651689.git.cyrille.pitchen@atmel.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Dec 2014 08:51:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Date: Mon, 15 Dec 2014 15:13:30 +0100

> This series of patches is a fixup for the multiqueue support patch.
> 
> The first patch fixes a bug introduced by the multiqueue support patch.
> The second one doesn't fix a bug but simplify the source code by removing
> useless calls to devm_free_irq() since we use managed device resources for
> IRQs.
> 
> They were applied on the net-next tree and tested with a sama5d36ek board.

Series applied, thanks.
