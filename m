Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaB0UXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:23:20 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49143 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaB0UXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:23:13 -0500
Date: Thu, 27 Feb 2014 15:23:08 -0500 (EST)
Message-Id: <20140227.152308.974173030016192682.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] atm: nicstar: remove interruptible_sleep_on_timeout
From: David Miller <davem@davemloft.net>
In-Reply-To: <201402271951.54970.arnd@arndb.de>
References: <1393412516-3762435-11-git-send-email-arnd@arndb.de>
	<20140226.110603.1107468127601575254.davem@davemloft.net>
	<201402271951.54970.arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2014 12:23:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 27 Feb 2014 19:51:54 +0100

> We are trying to finally kill off interruptible_sleep_on_timeout.
> the two uses in the nicstar driver can be trivially replaced
> with wait_event_interruptible_lock_irq_timeout, which prevents the
> wake-up race and is able to check the buffer state with scq->lock
> held.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>

Applied, thanks.
