Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947292Ab3BHWpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:45:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37999 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760366Ab3BHWpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:45:03 -0500
Date: Fri, 08 Feb 2013 17:45:00 -0500 (EST)
Message-Id: <20130208.174500.1518593039138341685.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net, wil6210@qca.qualcomm.com,
        brcm80211-dev-list@broadcom.com, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] drivers: net: Remove remaining alloc/OOM messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360273587.27863.15.camel@joe-AO722>
References: <1360273587.27863.15.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 07 Feb 2013 13:46:27 -0800

> alloc failures already get standardized OOM
> messages and a dump_stack.
> 
> For the affected mallocs around these OOM messages:
> 
> Converted kmallocs with multiplies to kmalloc_array.
> Converted a kmalloc/memcpy to kmemdup.
> Removed now unused stack variables.
> Removed unnecessary parentheses.
> Neatened alignment.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
