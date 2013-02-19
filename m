Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341Ab3BSSTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:19:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34438 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3BSSTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:19:16 -0500
Date: Tue, 19 Feb 2013 13:19:14 -0500 (EST)
Message-Id: <20130219.131914.578123633760866734.davem@davemloft.net>
To: kapranoff@inbox.ru
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, romieu@fr.zoreil.com
Subject: Re: [PATCH] NET/PHY: Eliminate the forced speed reduction
 algorithm.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361267628.4919.6.camel@kkk.nita.ru>
References: <1361267628.4919.6.camel@kkk.nita.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Feb 2013 10:19:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Kapranov <kapranoff@inbox.ru>
Date: Tue, 19 Feb 2013 13:53:48 +0400

> Tested at 2.6.38.7, applicable up to for 3.0.4. 
> Signed-off-by: Kirill Kapranov <kkk@nita.ru>,<kapranoff@inbox.ru>
>  --- linux/drivers/net/phy/phy.c.orig	2011-05-22 02:13:59.000000000 +0400
> +++ linux/drivers/net/phy/phy.c	2012-04-28 12:49:37.000000000 +0400

Your patches are continually poorly formatted, and corrupted by
your email client, which means that the patches cannot be applied
properly and all of our automated tools for patch tracking do not
recognize your submissions as a patch.
