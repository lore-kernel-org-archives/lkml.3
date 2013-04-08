Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605Ab3DHQJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:09:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49222 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934161Ab3DHQJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:09:45 -0400
Date: Mon, 08 Apr 2013 12:09:43 -0400 (EDT)
Message-Id: <20130408.120943.2116357191148187259.davem@davemloft.net>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mrf24j40: Enable link-layer acknowledgement and retry
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365194091-2542-1-git-send-email-alan@signal11.us>
References: <1365194091-2542-1-git-send-email-alan@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 08 Apr 2013 09:09:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Fri,  5 Apr 2013 16:34:51 -0400

> On the MRF24J40, link-layer acknowledgment request and retry must be
> turned on explicitly for each packet.  Turn this on in the hardware based
> on the FC_ACK_REQ bit being set in the packet.
> 
> Also, now that failure to receive an ACK will cause the hardware to report
> failure of transmission, change the log level for this failure to debug
> level.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>

Applied.
