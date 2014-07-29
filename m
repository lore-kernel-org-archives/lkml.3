Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaG2TTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:19:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48020 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaG2TS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:18:59 -0400
Date: Tue, 29 Jul 2014 12:18:56 -0700 (PDT)
Message-Id: <20140729.121856.1236100223837303806.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: hjlipp@web.de, tilman@imap.cc, isdn@linux-pingi.de,
        gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] isdn/bas_gigaset: fix a leak on failure path in
 gigaset_probe()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406327671-28271-1-git-send-email-khoroshilov@ispras.ru>
References: <1406327671-28271-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Jul 2014 12:18:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Sat, 26 Jul 2014 02:34:31 +0400

> There is a lack of usb_put_dev(udev) on failure path in gigaset_probe().
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Applied, thanks.
