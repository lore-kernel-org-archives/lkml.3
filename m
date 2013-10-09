Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab3JISE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 14:04:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50229 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab3JISEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 14:04:23 -0400
Date: Wed, 09 Oct 2013 14:04:21 -0400 (EDT)
Message-Id: <20131009.140421.1066887211157494658.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-10-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131009152841.GD14381@tuxdriver.com>
References: <20131009152841.GD14381@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 09 Oct 2013 11:04:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 9 Oct 2013 11:28:41 -0400

> Please pull this batch of fixes intended for 3.12...
> 
> Most of the bits are for iwlwifi -- Johannes says:
> 
> "I have a fix for WoWLAN/D3, a PCIe device fix, we're removing a
> warning, there's a fix for RF-kill while scanning (which goes together
> with a mac80211 fix) and last but not least we have many new PCI IDs."
> 
> Also for iwlwifi is a patch from Johannes to correct some merge damage
> that crept into the tree before the last merge window.
> 
> On top of that, Felix Fietkau sends an ath9k patch to avoid a Tx
> scheduling hang when changing channels to do a scan.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
