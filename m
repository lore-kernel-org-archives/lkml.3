Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3COM5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:57:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47054 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab3COM5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:57:24 -0400
Date: Fri, 15 Mar 2013 08:57:39 -0400 (EDT)
Message-Id: <20130315.085739.1428933964050018561.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-wireless@vger.kernel.org,
        wil6210@qca.qualcomm.com, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers:net: Remove dma_alloc_coherent OOM
 messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363302441.2146.30.camel@joe-AO722>
References: <1363302441.2146.30.camel@joe-AO722>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 15 Mar 2013 05:57:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 14 Mar 2013 16:07:21 -0700

> I believe these error messages are already logged
> on allocation failure by warn_alloc_failed and so
> get a dump_stack on OOM.
> 
> Remove the unnecessary additional error logging.
> 
> Around these deletions:
> 
> o Alignment neatening.
> o Remove unnecessary casts of dma_alloc_coherent.
> o Hoist assigns from ifs.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
