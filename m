Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaIJDLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:11:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35413 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaIJDLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:11:33 -0400
Date: Tue, 09 Sep 2014 20:11:29 -0700 (PDT)
Message-Id: <20140909.201129.274222387243042834.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: use usleep_range
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-35-Taiwan-albertk@realtek.com>
References: <1394712342-15778-35-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Sep 2014 20:11:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 9 Sep 2014 11:40:28 +0800

> Replace mdelay with usleep_range to avoid busy loop.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
