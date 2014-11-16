Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbaKPTU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:20:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37734 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaKPTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:20:25 -0500
Date: Sun, 16 Nov 2014 14:20:20 -0500 (EST)
Message-Id: <20141116.142020.1374564946936115095.davem@davemloft.net>
To: john.ogness@linutronix.de
Cc: linux-kernel@vger.kernel.org, mugunthanvnm@ti.com, balbi@ti.com,
        george.cherian@ti.com, jhovold@gmail.com, mpa@pengutronix.de,
        bhutchings@solarflare.com, zonque@gmail.com, tklauser@distanz.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: net: cpsw: Fix TX_IN_SEL offset
From: David Miller <davem@davemloft.net>
In-Reply-To: <87sihlj11v.fsf@linutronix.de>
References: <87sihlj11v.fsf@linutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Nov 2014 11:20:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>
Date: Fri, 14 Nov 2014 15:42:52 +0100

> The TX_IN_SEL offset for the CPSW_PORT/TX_IN_CTL register was
> incorrect. This caused the Dual MAC mode to never get set when
> it should. It also caused possible unintentional setting of a
> bit in the CPSW_PORT/TX_BLKS_REM register.
> 
> The purpose of setting the Dual MAC mode for this register is to:
> 
>     "... allow packets from both ethernet ports to be written into
>      the FIFO without one port starving the other port."
> 					- AM335x ARM TRM
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

Applied, thanks.
