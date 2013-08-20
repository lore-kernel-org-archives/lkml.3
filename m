Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab3HTU1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:27:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46685 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3HTU1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:27:49 -0400
Date: Tue, 20 Aug 2013 13:27:48 -0700 (PDT)
Message-Id: <20130820.132748.2038341239691937544.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] via-ircc: don't return zero if via_ircc_open() failed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376686094-28780-1-git-send-email-khoroshilov@ispras.ru>
References: <1376686094-28780-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 20 Aug 2013 13:27:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Fri, 16 Aug 2013 23:48:14 +0300

> If via_ircc_open() fails, data structures of the driver left uninitialized,
> but probe (via_init_one()) returns zero. That can lead to null pointer dereference
> in via_remove_one(), since it does not check drvdata for NULL.
> 
> The patch implements proper error code propagation.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Applied, thanks.
