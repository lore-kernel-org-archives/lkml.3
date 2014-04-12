Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbaDLUvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 16:51:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38667 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaDLUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 16:51:54 -0400
Date: Sat, 12 Apr 2014 16:51:52 -0400 (EDT)
Message-Id: <20140412.165152.1877473530496221304.davem@davemloft.net>
To: v.maffione@gmail.com
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: xen-netfront: fix array initialization
 bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397296540-3007-1-git-send-email-v.maffione@gmail.com>
References: <1397296540-3007-1-git-send-email-v.maffione@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 12 Apr 2014 13:51:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincenzo Maffione <v.maffione@gmail.com>
Date: Sat, 12 Apr 2014 11:55:40 +0200

> This patch fixes the initialization of an array used in the TX
> datapath that was mistakenly initialized together with the
> RX datapath arrays. An out of range array access could happen
> when RX and TX rings had different sizes.
> 
> Signed-off-by: Vincenzo Maffione <v.maffione@gmail.com>

Good catch, applied, thanks.
