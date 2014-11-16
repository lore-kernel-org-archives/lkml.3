Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbaKPTpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:45:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37982 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaKPTpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:45:49 -0500
Date: Sun, 16 Nov 2014 14:45:46 -0500 (EST)
Message-Id: <20141116.144546.301780663386181251.davem@davemloft.net>
To: marcel@holtmann.org
Cc: alex.aring@gmail.com, khoroshilov@ispras.ru, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] ieee802154: fix error handling in
 ieee802154fake_probe()
From: David Miller <davem@davemloft.net>
In-Reply-To: <B1D43522-B042-4D92-8F8A-D2AD89A3F0F9@holtmann.org>
References: <1416006719-3450-1-git-send-email-khoroshilov@ispras.ru>
	<20141115071603.GA3481@omega>
	<B1D43522-B042-4D92-8F8A-D2AD89A3F0F9@holtmann.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Nov 2014 11:45:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Sat, 15 Nov 2014 16:58:28 +0900

> Dave, do you want to just take it via net-stable tree? We currently
> have no urgent bluetooth-stable tree patches pending.

Yeah I can do that, applied and queued up for -stable, thanks.
