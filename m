Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab3A1ANq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 19:13:46 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36694 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab3A1ANn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 19:13:43 -0500
Date: Sun, 27 Jan 2013 19:13:41 -0500 (EST)
Message-Id: <20130127.191341.444561143405489074.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH] gro: Fix kcalloc argument order
From: David Miller <davem@davemloft.net>
In-Reply-To: <1359228259.2079.30.camel@joe-AO722>
References: <1359228259.2079.30.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 26 Jan 2013 11:24:19 -0800

> First number, then size.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Good catch, since this bug doesn't cause any real functional problem
I've applied the patch to net-next.

Thanks.
