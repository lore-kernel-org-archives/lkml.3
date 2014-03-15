Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaCOCj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 22:39:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41536 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbaCOCj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 22:39:27 -0400
Date: Fri, 14 Mar 2014 22:39:25 -0400 (EDT)
Message-Id: <20140314.223925.1612925351139021751.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: f.fainelli@gmail.com, ben@decadent.org.uk, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: fix uninitalized ethtool_wolinfo in
 phy_suspend
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394788064-6832-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <20140313.153832.967564223480298567.davem@davemloft.net>
	<1394788064-6832-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Mar 2014 19:39:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Fri, 14 Mar 2014 10:07:44 +0100

> Callers of phy_ethtool_get_wol are supposed to provide a properly
> cleared struct ethtool_wolinfo. Therefore, fix phy_suspend to clear
> it before passing it to phy_ethtool_get_wol.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Applied, thanks.
