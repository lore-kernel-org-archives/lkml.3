Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3DNToB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 15:44:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48553 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3DNToA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 15:44:00 -0400
Date: Sun, 14 Apr 2013 15:43:58 -0400 (EDT)
Message-Id: <20130414.154358.755597670486116198.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, festevam@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] freescale: Update logging style
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1365915548.git.joe@perches.com>
References: <cover.1365915548.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 14 Apr 2013 12:44:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 13 Apr 2013 22:03:16 -0700

> Convert various printk logging styles to current styles.
> 
> Uncompiled, untested.
> 
> Joe Perches (3):
>   fec: Convert printks to netdev_<level>
>   gianfar: Use netdev_<level> when possible
>   ucc_geth: Convert ugeth_<level> to pr_<level>

All applied.
