Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab3BOSyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:54:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43536 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3BOSyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:54:08 -0500
Date: Fri, 15 Feb 2013 13:54:05 -0500 (EST)
Message-Id: <20130215.135405.621356363510662497.davem@davemloft.net>
To: kapranoff@inbox.ru
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET/PHY: Eliminate the algorithm of forced ethernet
 speed reduction
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360925459.4709.23.camel@kkk.nita.ru>
References: <1360925459.4709.23.camel@kkk.nita.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Kapranov <kapranoff@inbox.ru>
Date: Fri, 15 Feb 2013 14:50:59 +0400

> NET/PHY: Eliminate the forced speed reduction algorithm.
> In case of the fixed speed set up for NIC 
> 	(e.g. ethtool -s eth0 autoneg off speed 100 duplex full)
> 	with ethernet cable plugged off, mentioned algorithm 
> 	slows down NIC speed, so the further "hooking up" gives 
> 	no result. AFAIK, this behaviour is not RFCs' recommended.
> Tested at 2.6.38.7, applicable up to for 3.0.4. 
> Signed-off-by: Kirill Kapranov <kkk@nita.ru>,<kapranoff@inbox.ru>

This is formatted very unpleasantly, please put some care into
the formatting of your commit message, as if you were writing an
important letter to someone and you wanted it to look very nice.
