Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbaIPT6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:58:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57642 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaIPT4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:56:30 -0400
Date: Tue, 16 Sep 2014 15:56:27 -0400 (EDT)
Message-Id: <20140916.155627.1263306577960098199.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        romieu@fr.zoreil.com
Subject: Re: [PATCH net] r8169: adjust __rtl8169_set_features
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-42-Taiwan-albertk@realtek.com>
References: <20140916000321.GA19564@electric-eye.fr.zoreil.com>
	<1394712342-15778-42-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Sep 2014 12:56:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 16 Sep 2014 11:40:47 +0800

> Remove the "changed" test in __rtl8169_set_features(). Instead, do
> simple test in rtl8169_set_features().
> 
> Set the RxChkSum and RxVlan through __rtl8169_set_features() in
> rtl_open().
> 
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
