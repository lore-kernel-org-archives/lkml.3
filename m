Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaBRXPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:15:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37118 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaBRXO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:14:57 -0500
Date: Tue, 18 Feb 2014 18:14:55 -0500 (EST)
Message-Id: <20140218.181455.1318635286870307922.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, arvid.brodin@alten.se,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] hsr: Use ether_addr_copy
From: David Miller <davem@davemloft.net>
In-Reply-To: <675e6a59ebb87d5e18633df578a62a1202f6172e.1392748500.git.joe@perches.com>
References: <675e6a59ebb87d5e18633df578a62a1202f6172e.1392748500.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2014 15:14:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 18 Feb 2014 10:37:20 -0800

> It's slightly smaller/faster for some architectures.
> Make sure def_multicast_addr is __aligned(2)
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
