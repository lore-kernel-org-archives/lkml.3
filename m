Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3JAGBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 02:01:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43212 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3JAGBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 02:01:38 -0400
Date: Tue, 01 Oct 2013 02:01:34 -0400 (EDT)
Message-Id: <20131001.020134.756782177490714135.davem@davemloft.net>
To: ricardo.ribalda@gmail.com
Cc: joe@perches.com, jg1.han@samsung.com, gregkh@linuxfoundation.org,
        wfp5p@virginia.edu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ll_temac: Reset dma descriptors on ndo_open
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAPybu_0OrwTo7CkuauRpu_ohQRY80U6BJDXQ6=KC0caOFiFCQA@mail.gmail.com>
References: <1380281068-13269-1-git-send-email-ricardo.ribalda@gmail.com>
	<20130930.212153.531876068589922786.davem@davemloft.net>
	<CAPybu_0OrwTo7CkuauRpu_ohQRY80U6BJDXQ6=KC0caOFiFCQA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 30 Sep 2013 23:01:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 1 Oct 2013 07:46:31 +0200

> What if I move
>        lp->tx_bd_ci = 0;
>        lp->tx_bd_next = 0;
>        lp->tx_bd_tail = 0;
>        lp->rx_bd_ci = 0;
> 
> to temac_dma_bd_init? Will this be more correct?

Yes, that would be a lot better.
