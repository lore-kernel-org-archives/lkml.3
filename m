Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbaLKTwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:52:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56003 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaLKTwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:52:30 -0500
Date: Thu, 11 Dec 2014 14:52:26 -0500 (EST)
Message-Id: <20141211.145226.1360190108417194167.davem@davemloft.net>
To: cyrille.pitchen@atmel.com
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, soren.brinkmann@xilinx.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net/macb: fix compilation warning for
 print_hex_dump() called with skb->mac_header
From: David Miller <davem@davemloft.net>
In-Reply-To: <efa28485b430e77f5254248cb396da431d03fc5b.1418292741.git.cyrille.pitchen@atmel.com>
References: <efa28485b430e77f5254248cb396da431d03fc5b.1418292741.git.cyrille.pitchen@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Dec 2014 11:52:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Date: Thu, 11 Dec 2014 11:15:54 +0100

> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>

Applied, thanks.
