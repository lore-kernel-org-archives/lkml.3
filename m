Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3BDSXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:23:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43998 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab3BDSXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:23:39 -0500
Date: Mon, 04 Feb 2013 13:23:35 -0500 (EST)
Message-Id: <20130204.132335.1757403310770538446.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-hams@vger.kernel.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org, wimax@linuxwimax.org,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        libertas-dev@lists.infradead.org
Subject: Re: [PATCH 0/8] drivers/net: Remove unnecessary alloc/OOM messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1359939012.git.joe@perches.com>
References: <cover.1359939012.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun,  3 Feb 2013 19:28:07 -0800

> Remove all the OOM messages that follow kernel alloc
> failures as there is already a generic equivalent to
> these messages in the mm subsystem.
> 
> Joe Perches (8):
>   caif: Remove unnecessary alloc/OOM messages
>   can: Remove unnecessary alloc/OOM messages
>   ethernet: Remove unnecessary alloc/OOM messages, alloc cleanups
>   drivers: net: usb: Remove unnecessary alloc/OOM messages
>   wan: Remove unnecessary alloc/OOM messages
>   wimax: Remove unnecessary alloc/OOM messages, alloc cleanups
>   wireless: Remove unnecessary alloc/OOM messages, alloc cleanups
>   drivers:net:misc: Remove unnecessary alloc/OOM messages

Series applied, thanks Joe.
