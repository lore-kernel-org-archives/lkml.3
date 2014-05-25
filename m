Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaEYDdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 23:33:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40534 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaEYDdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 23:33:49 -0400
Date: Sat, 24 May 2014 23:33:45 -0400 (EDT)
Message-Id: <20140524.233345.1406269413034915848.davem@davemloft.net>
To: Wei.Yang@windriver.com
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: driver: stmicro: Remove some useless the lock
 protection
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400982824-3871-1-git-send-email-Wei.Yang@windriver.com>
References: <20140523.160945.226886017757584215.davem@davemloft.net>
	<1400982824-3871-1-git-send-email-Wei.Yang@windriver.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 May 2014 20:33:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <Wei.Yang@windriver.com>
Date: Sun, 25 May 2014 09:53:44 +0800

> From: Yang Wei <Wei.Yang@windriver.com>
> 
> kernel always invokes a pair of rtnl_lock adn rtnl_unlock to
> protect dev_ethtool(), so its not neccessary to invoke spin_lock/unlock
> in ethtool_ops.
> 
> Signed-off-by: Yang Wei <Wei.Yang@windriver.com>

Applied to net-next, thanks.
