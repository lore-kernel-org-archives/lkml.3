Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbaHZAhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:37:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39988 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaHZAhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:37:38 -0400
Date: Mon, 25 Aug 2014 17:37:37 -0700 (PDT)
Message-Id: <20140825.173737.2231823536257512393.davem@davemloft.net>
To: rdunlap@infradead.org
Cc: linux-next@vger.kernel.org, netdev@vger.kernel.org, jim.epost@gmail.com,
        linux-kernel@vger.kernel.org, ariel.elior@qlogic.com
Subject: Re: [PATCH] net: bnx2x: fix build error with ptp
From: David Miller <davem@davemloft.net>
In-Reply-To: <53FB9910.3020601@infradead.org>
References: <53FB9884.8000707@infradead.org>
	<53FB9910.3020601@infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 17:37:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 25 Aug 2014 13:14:08 -0700

> Note: This patch fixes a build error in linux-next (not in mainline).

Applied to net-next, thanks Randy.

You can put "[PATCH net-next]" into your subject line to make this
explicit next time.
