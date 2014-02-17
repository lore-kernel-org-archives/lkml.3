Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaBQT3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:29:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50467 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaBQT3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:29:34 -0500
Date: Mon, 17 Feb 2014 14:29:32 -0500 (EST)
Message-Id: <20140217.142932.2241202017756551476.davem@davemloft.net>
To: tommie@gannert.se
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irtty-sir.c: Do not set_termios() on irtty_close()
From: David Miller <davem@davemloft.net>
In-Reply-To: <52FC87B6.4070001@gannert.se>
References: <52FC87B6.4070001@gannert.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2014 11:29:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tommie Gannert <tommie@gannert.se>
Date: Thu, 13 Feb 2014 08:52:06 +0000

> --- linux-3.12/drivers/net/irda/irtty-sir.c.orig 2014-02-12
> --- 21:36:46.132496089 +0000
> +++ linux-3.12/drivers/net/irda/irtty-sir.c 2014-02-12
> 21:57:21.635843884 +0000
> @@ -521,7 +521,6 @@ static void irtty_close(struct tty_struc
>  	sirdev_put_instance(priv->dev);
>    	/* Stop tty */
> -	irtty_stop_receiver(tty, TRUE);
>  	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
>  	if (tty->ops->stop)
>  		tty->ops->stop(tty);

This patch has been corrupted by your email client.  Please fix this
up and resubmit, thanks.
