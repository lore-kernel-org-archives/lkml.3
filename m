Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaCFWGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:06:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33984 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaCFWGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:06:52 -0500
Date: Thu, 06 Mar 2014 17:06:49 -0500 (EST)
Message-Id: <20140306.170649.2053437094145326106.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: fubar@us.ibm.com, vfalico@redhat.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikolay@redhat.com
Subject: Re: [PATCH v2] bonding: correctly handle out of range parameters
 for lp_interval
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394142791-11142-1-git-send-email-sasha.levin@oracle.com>
References: <1394142791-11142-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 14:06:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Thu,  6 Mar 2014 16:53:11 -0500

> We didn't correctly check cases where the value for lp_interval is not
> within the legal range due to a missing table terminator.
> 
> This would let userspace trigger a kernel panic by specifying a value out
> of range:
> 
> 	echo -1 > /sys/devices/virtual/net/bond0/bonding/lp_interval
> 
> Introduced by commit 4325b374f84 ("bonding: convert lp_interval to use
> the new option API").
> 
> Acked-by: Nikolay Aleksandrov <nikolay@redhat.com>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Applied, thanks.
