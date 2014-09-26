Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaIZUNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:13:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50784 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbaIZUNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:13:33 -0400
Date: Fri, 26 Sep 2014 16:13:30 -0400 (EDT)
Message-Id: <20140926.161330.1243504275428423559.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: fix the carrier off when autoresuming
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-45-Taiwan-albertk@realtek.com>
References: <1394712342-15778-45-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Sep 2014 13:13:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 23 Sep 2014 16:31:47 +0800

> netif_carrier_off would be called when autoresuming, even though
> the cable is plugged. This causes some applications do relative
> actions when detecting the carrier off. Keep the status of the
> carrier, and let it be modified when the linking change occurs.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
