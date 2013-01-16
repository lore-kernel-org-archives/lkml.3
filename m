Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab3APVWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:22:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39381 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab3APVWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:22:17 -0500
Date: Wed, 16 Jan 2013 16:22:14 -0500 (EST)
Message-Id: <20130116.162214.444431638469568669.davem@davemloft.net>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony.cheneau@amnesiak.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH 2/2] 6lowpan: Handle uncompressed IPv6 packets over
 6LoWPAN
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358315037-10043-3-git-send-email-alan@signal11.us>
References: <1358315037-10043-1-git-send-email-alan@signal11.us>
	<1358315037-10043-3-git-send-email-alan@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Wed, 16 Jan 2013 00:43:57 -0500

> +		local_skb = skb_copy_expand(skb, NET_SKB_PAD - 1,
> +						skb_tailroom(skb), GFP_ATOMIC);

This is not indented properly.

When a function call spans multiple lines, the second and subsequent
lines should be indented to the column right after the openning
parenthesis of the call itself, using a combination of TAB and
SPC characters as needed.

