Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbaDXQiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:38:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60652 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbaDXQiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:38:17 -0400
Date: Thu, 24 Apr 2014 12:36:26 -0400 (EDT)
Message-Id: <20140424.123626.601551201909346659.davem@davemloft.net>
To: mcgrof@do-not-panic.com
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, backports@vger.kernel.org,
        mcgrof@suse.com, johannes@sipsolutions.net
Subject: Re: [PATCH] 6lowpan: nuke net_ieee802154_lowpan() accessor when
 6lowpan is disabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398193438-23805-1-git-send-email-mcgrof@do-not-panic.com>
References: <1398193438-23805-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Apr 2014 09:38:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 22 Apr 2014 12:03:58 -0700

> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> Johannes noted this is not needed, all of the fragment
> accessors don't need CONFIG_NET_NS. This goes test compiled with
> CONFIG_BT_6LOWPAN=y and a disabled CONFIG_NET_NS.
> 
> CC: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: linux-zigbee-devel@lists.sourceforge.net
> Cc: David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

Applied, thanks Luis.
