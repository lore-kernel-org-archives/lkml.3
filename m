Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711Ab3DHQJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:09:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49230 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934098Ab3DHQJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:09:54 -0400
Date: Mon, 08 Apr 2013 12:09:52 -0400 (EDT)
Message-Id: <20130408.120952.822851879685807558.davem@davemloft.net>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mac802154: Keep track of the channel when changed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365202990-9006-1-git-send-email-alan@signal11.us>
References: <515F4017.6060404@signal11.us>
	<1365202990-9006-1-git-send-email-alan@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 08 Apr 2013 09:09:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Fri,  5 Apr 2013 19:03:10 -0400

> Two sections checked whether the current channel != the new channel
> without ever setting the current channel variables.
> 
> 1. net/mac802154/tx.c: Prevent set_channel() from getting called every
> time a packet is sent.
> 
> 2. net/mac802154/mib.c: Lock (pib_lock) accesses to current_channel and
> current_page and make sure they are updated when the channel has been
> changed.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>

Applied.
