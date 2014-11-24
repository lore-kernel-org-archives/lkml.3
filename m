Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875AbaKXVPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:15:01 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53769 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKXVPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:15:00 -0500
Date: Mon, 24 Nov 2014 16:14:57 -0500 (EST)
Message-Id: <20141124.161457.416165119227187597.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: wei.liu2@citrix.com, ian.campbell@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] xen-netback: do not report success if
 backend_create_xenvif() fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416826680-19145-1-git-send-email-khoroshilov@ispras.ru>
References: <20141124100053.GC30053@zion.uk.xensource.com>
	<1416826680-19145-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Nov 2014 13:14:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Mon, 24 Nov 2014 13:58:00 +0300

> If xenvif_alloc() or xenbus_scanf() fail in backend_create_xenvif(),
> xenbus is left in offline mode but netback_probe() reports success.
> 
> The patch implements propagation of error code for backend_create_xenvif().
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Applied, thanks.
