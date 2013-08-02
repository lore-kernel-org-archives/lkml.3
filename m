Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3HBTes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:34:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40916 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab3HBTeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:34:46 -0400
Date: Fri, 02 Aug 2013 12:34:42 -0700 (PDT)
Message-Id: <20130802.123442.500196593983076682.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, wimax@linuxwimax.org
Subject: Re: [PATCH V3 0/3] networking: Use ETH_ALEN where appropriate
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1375398692.git.joe@perches.com>
References: <20130801.143137.331385226409040561.davem@davemloft.net>
	<cover.1375398692.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 02 Aug 2013 12:34:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu,  1 Aug 2013 16:17:46 -0700

> Convert the uses mac addresses to ETH_ALEN so
> it's easier to find and verify where mac addresses
> need to be __aligned(2)

Series applied to net-next, thanks.
