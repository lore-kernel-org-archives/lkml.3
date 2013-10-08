Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3JHT3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:29:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53983 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3JHT3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:29:13 -0400
Date: Tue, 08 Oct 2013 15:29:11 -0400 (EDT)
Message-Id: <20131008.152911.2206663013355897986.davem@davemloft.net>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        alex.aring@gmail.com, linux-zigbee-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] 6lowpan default hardware address
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381029319-6835-1-git-send-email-alan@signal11.us>
References: <1381029319-6835-1-git-send-email-alan@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 08 Oct 2013 12:29:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Sat,  5 Oct 2013 23:15:17 -0400

> Alexander Aring suggested that devices desired to be linked to 6lowpan
> be checked for actually being of type IEEE802154, since IEEE802154 devices
> are all that are supported by 6lowpan at present.
> 
> Alan Ott (2):
>   6lowpan: Only make 6lowpan links to IEEE802154 devices
>   6lowpan: Sync default hardware address of lowpan links to their wpan

Series applied, thanks Alan.
