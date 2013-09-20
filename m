Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3ITTjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:39:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40014 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3ITTjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:39:21 -0400
Date: Fri, 20 Sep 2013 15:39:17 -0400 (EDT)
Message-Id: <20130920.153917.223605052660606273.davem@davemloft.net>
To: nautsch2@gmail.com
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/3] SLCAN/SLIP fixes and performance
From: David Miller <davem@davemloft.net>
In-Reply-To: <1379093833-4949-1-git-send-email-nautsch2@gmail.com>
References: <1379093833-4949-1-git-send-email-nautsch2@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 20 Sep 2013 12:39:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Naujoks <nautsch2@gmail.com>
Date: Fri, 13 Sep 2013 19:37:10 +0200

> these are some loosely related patches, that fix an ancient locking problem in
> the slip and slcan drivers, add general ASCII-HEX to bin functions for
> uppercase ASCII, fix the handling of CAN RTR frames in the slcan driver
> and increase the performance for the slcan driver.
> 
> As these patches mainly contain fixes for the slip/slcan drivers that require
> a tty layer fix included in 3.11, I would suggest to get the patches in via
> the net tree for the 3.12 cycle. They should apply properly on the latest net
> and mainline tree.

Applied thanks.
