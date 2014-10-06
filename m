Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaJFVv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:51:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38524 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaJFVvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:51:55 -0400
Date: Mon, 06 Oct 2014 17:51:53 -0400 (EDT)
Message-Id: <20141006.175153.1903557065173052671.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2] r8152: nway reset after setting eee
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-57-Taiwan-albertk@realtek.com>
References: <1394712342-15778-54-Taiwan-albertk@realtek.com>
	<1394712342-15778-57-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Oct 2014 14:51:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 6 Oct 2014 10:36:04 +0800

> Restart autonegotiation is necessary after setting EEE.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
