Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaBRXPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:15:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37127 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaBRXPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:15:09 -0500
Date: Tue, 18 Feb 2014 18:15:07 -0500 (EST)
Message-Id: <20140218.181507.1046967430290052114.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, jesse@nicira.com, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] openvswitch: Use ether_addr_copy
From: David Miller <davem@davemloft.net>
In-Reply-To: <fee7d53a1cfdec0aec7ea35a1f2f4b5e66766ee3.1392750899.git.joe@perches.com>
References: <fee7d53a1cfdec0aec7ea35a1f2f4b5e66766ee3.1392750899.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2014 15:15:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 18 Feb 2014 11:15:45 -0800

> It's slightly smaller/faster for some architectures.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I'll let Jesse take this via his tree, thanks Joe.
