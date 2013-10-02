Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3JBVF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:05:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49401 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab3JBVFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:05:24 -0400
Date: Wed, 02 Oct 2013 17:05:21 -0400 (EDT)
Message-Id: <20131002.170521.463969346066312216.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, e1000-devel@lists.sourceforge.net,
        linux-usb@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
        bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] net:drivers/net: Miscellaneous conversions to
 ETH_ALEN
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380679480.2081.24.camel@joe-AO722>
References: <1380679480.2081.24.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 02 Oct 2013 14:05:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 01 Oct 2013 19:04:40 -0700

> Convert the memset/memcpy uses of 6 to ETH_ALEN
> where appropriate.
> 
> Also convert some struct definitions and u8 array
> declarations of [6] to ETH_ALEN.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Looks fine, applied, thanks Joe.
