Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3K1Xi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 18:38:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47452 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab3K1Xi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 18:38:56 -0500
Date: Thu, 28 Nov 2013 18:38:54 -0500 (EST)
Message-Id: <20131128.183854.1965568926565257648.davem@davemloft.net>
To: apw@canonical.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] xen-netback: include definition of csum_ipv6_magic
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385398354-21636-1-git-send-email-apw@canonical.com>
References: <1385398354-21636-1-git-send-email-apw@canonical.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 28 Nov 2013 15:38:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>
Date: Mon, 25 Nov 2013 16:52:34 +0000

> We are now using csum_ipv6_magic, include the appropriate header.
> Avoids the following error:
> 
>     drivers/net/xen-netback/netback.c:1313:4: error: implicit declaration of function 'csum_ipv6_magic' [-Werror=implicit-function-declaration]
>         tcph->check = ~csum_ipv6_magic(&ipv6h->saddr,
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Applied, thank you.
