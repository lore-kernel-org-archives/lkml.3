Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3JVGSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 02:18:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48996 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3JVGSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 02:18:07 -0400
Date: Tue, 22 Oct 2013 02:18:05 -0400 (EDT)
Message-Id: <20131022.021805.1325709347250113490.davem@davemloft.net>
To: gamerh2o@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: remove function sk_reset_txq()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131022041124.GA14122@will>
References: <20131022041124.GA14122@will>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 21 Oct 2013 23:18:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ZHAO Gang <gamerh2o@gmail.com>
Date: Tue, 22 Oct 2013 12:11:24 +0800

> What sk_reset_txq() does is just calls function sk_tx_queue_reset(),
> and sk_reset_txq() is used only in sock.h, by dst_negative_advice().
> Let dst_negative_advice() calls sk_tx_queue_reset() directly so we
> can remove unneeded sk_reset_txq().
> 
> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>

Still doesn't apply.

Email this patch to yourself, I bet the patch you receive won't
apply cleanly.  Likely your email client is corrupting the patch.

You've already eaten enough of my time as a maintainer submitting
a patch that won't even apply.  Absolutely do not resubmit this
patch until you can email the patch successfully to yourself
and successfuly apply the patch you receive in that email to
the current net-next tree.
