Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab3DLRXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:23:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51114 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab3DLRXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:23:15 -0400
Date: Fri, 12 Apr 2013 13:23:14 -0400 (EDT)
Message-Id: <20130412.132314.1519520714787939726.davem@davemloft.net>
To: jhovold@gmail.com
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, peter@hurleysoftware.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] TTY: ircomm: fix DTR being raised on hang up
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365755551-17824-5-git-send-email-jhovold@gmail.com>
References: <1365755551-17824-1-git-send-email-jhovold@gmail.com>
	<1365755551-17824-5-git-send-email-jhovold@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 12 Apr 2013 10:23:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>
Date: Fri, 12 Apr 2013 10:32:31 +0200

> Make sure to check ASYNC_INITIALISED before raising DTR when waking up
> from blocked open in ircomm_tty_block_til_ready.
> 
> Currently DTR could get raised at hang up as a blocked process would
> raise DTR unconditionally before checking for hang up and returning.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
