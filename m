Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaGIXoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:44:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34628 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaGIXoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:44:21 -0400
Date: Wed, 09 Jul 2014 16:44:20 -0700 (PDT)
Message-Id: <20140709.164420.157865201153845876.davem@davemloft.net>
To: mugunthanvnm@ti.com
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 0/3] Broadcast/Multicast rate limit via
 Ethtool Coalesce
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404890050-4020-1-git-send-email-mugunthanvnm@ti.com>
References: <1404890050-4020-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 09 Jul 2014 16:44:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mugunthan V N <mugunthanvnm@ti.com>
Date: Wed, 9 Jul 2014 12:44:07 +0530

> A system/cpu can be loaded by a hacker with flooding of broadcast or
> multicast packets, to prevent this some Ethernet controllers like CPSW
> provide a mechanism to limit the broadcast/multicast packet rate via
> hardware limiters. This patch series enables this feature via
> Ethtool Coalesce.

This is pretty bogus if you ask me.

What is the difference from accepting a high rate of unicast packets?
I say it is no different.

Therefore, this feature makes no sense to me at all.
