Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaIMUtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 16:49:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38011 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaIMUta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 16:49:30 -0400
Date: Sat, 13 Sep 2014 16:49:28 -0400 (EDT)
Message-Id: <20140913.164928.1225783213857458459.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2] r8152: support VLAN
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-37-Taiwan-albertk@realtek.com>
References: <1394712342-15778-36-Taiwan-albertk@realtek.com>
	<1394712342-15778-37-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Sep 2014 13:49:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 12 Sep 2014 10:43:11 +0800

> Support hw VLAN for tx and rx. And enable them by default.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
