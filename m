Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaEGTYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:24:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51055 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaEGTYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:24:35 -0400
Date: Wed, 07 May 2014 15:24:33 -0400 (EDT)
Message-Id: <20140507.152433.1601521913694225915.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w83977af_ir: remove two faux Kconfig macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399201392.8729.7.camel@x220>
References: <1399201392.8729.7.camel@x220>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 07 May 2014 12:24:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Sun, 04 May 2014 13:03:12 +0200

> Ever since v2.3.5 the driver for "Winbond W83977AF (IR)" contains two
> unneeded preprocessor macros.
> 
> CONFIG_NETWINDER_TX_DMA_PROBLEMS is never defined and can safely be
> removed. And CONFIG_NETWINDER_RX_DMA_PROBLEMS is just an alias for
> CONFIG_ARCH_NETWINDER, so that (valid) Kconfig macro can be used
> instead.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Compile tested only (on x86_64, that is).
> 
> I sneaked in a related whitespace fix.

Applied to net-next, thanks.
