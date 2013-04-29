Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab3D2R1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:27:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59101 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3D2R1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:27:11 -0400
Date: Mon, 29 Apr 2013 13:27:08 -0400 (EDT)
Message-Id: <20130429.132708.1188315001953129841.davem@davemloft.net>
To: arnd@arndb.de
Cc: chas@cmf.nrl.navy.mil, David.Laight@aculab.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 05/21] atm: he: use msleep instead of large udelay
 constants
From: David Miller <davem@davemloft.net>
In-Reply-To: <201304291513.27104.arnd@arndb.de>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B7203@saturn3.aculab.com>
	<20130426091220.468cf59e@thirdoffive.cmf.nrl.navy.mil>
	<201304291513.27104.arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 29 Apr 2013 10:27:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 29 Apr 2013 15:13:26 +0200

> From a0ddf082821b064cc2d6a9bb90861f9b81a559a5 Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Thu, 14 Mar 2013 15:21:36 +0100
> Subject: [PATCH] atm: he: use mdelay instead of large udelay constants
> 
> ARM cannot handle udelay for more than 2 miliseconds, and
> it is rather bad style to block the cpu for 16ms anyway,
> so let's use msleep instead.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.
