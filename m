Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaA2CGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 21:06:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48109 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaA2CGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 21:06:24 -0500
Date: Tue, 28 Jan 2014 18:06:23 -0800 (PST)
Message-Id: <20140128.180623.2101072474797169949.davem@davemloft.net>
To: standby24x7@gmail.com
Cc: trivial@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] net: Fix warning on make htmldocs caused by
 skbuff.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1390925128-20768-1-git-send-email-standby24x7@gmail.com>
References: <1390925128-20768-1-git-send-email-standby24x7@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>
Date: Wed, 29 Jan 2014 01:05:28 +0900

> This patch fixed following Warning while executing "make htmldocs".
> 
> Warning(/net/core/skbuff.c:2164): No description found for parameter 'from'
> Warning(/net/core/skbuff.c:2164): Excess function parameter 'source'
> description in 'skb_zerocopy'
> Replace "@source" with "@from" fixed the warning.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Applied, thank you.
