Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab3JUVSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:18:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43236 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3JUVSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:18:31 -0400
Date: Mon, 21 Oct 2013 17:18:29 -0400 (EDT)
Message-Id: <20131021.171829.2297768337604122109.davem@davemloft.net>
To: gamerh2o@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: remove function sk_reset_txq()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131020013757.GA25265@will>
References: <20131020013757.GA25265@will>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 21 Oct 2013 14:18:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ZHAO Gang <gamerh2o@gmail.com>
Date: Sun, 20 Oct 2013 09:37:57 +0800

> What sk_reset_txq() does is just calls function sk_tx_queue_reset(),
> and sk_reset_txq() is used only in sock.h, by dst_negative_advice().
> Let dst_negative_advice() calls sk_tx_queue_reset() directly so we
> can remove unneeded sk_reset_txq().
> 
> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
> change a typo in patch description: sock.c -> sock.h

This patch does not apply cleanly to net-next, please fix this up
and resubmit.

Thanks.
