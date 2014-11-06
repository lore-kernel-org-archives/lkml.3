Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaKFDRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:17:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50759 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaKFDRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:17:37 -0500
Date: Wed, 05 Nov 2014 22:17:34 -0500 (EST)
Message-Id: <20141105.221734.1934150161399944443.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: disable the tasklet by default
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-83-Taiwan-albertk@realtek.com>
References: <1394712342-15778-83-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Nov 2014 19:17:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 5 Nov 2014 10:17:02 +0800

> Let the tasklet only be enabled after open(), and be disabled for
> the other situation. The tasklet is only necessary after open() for
> tx/rx, so it could be disabled by default.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
