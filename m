Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaJFBTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 21:19:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56527 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaJFBTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 21:19:18 -0400
Date: Sun, 05 Oct 2014 21:19:16 -0400 (EDT)
Message-Id: <20141005.211916.2141017785429102158.davem@davemloft.net>
To: antoine.tenart@free-electrons.com
Cc: dan.carpenter@oracle.com, sebastian.hesselbarth@gmail.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] net: pxa168_eth: avoid using signed char for
 bitops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412348899-20586-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1412348899-20586-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Oct 2014 18:19:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Tenart <antoine.tenart@free-electrons.com>
Date: Fri,  3 Oct 2014 17:08:19 +0200

> Signedness bugs may occur when using signed char for bitops,
> depending on if the highest bit is ever used.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks.
