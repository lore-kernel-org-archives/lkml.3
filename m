Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3JAQcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:32:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54617 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3JAQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:32:29 -0400
Date: Tue, 01 Oct 2013 12:32:25 -0400 (EDT)
Message-Id: <20131001.123225.1741210078792586013.davem@davemloft.net>
To: ricardo.ribalda@gmail.com
Cc: joe@perches.com, jg1.han@samsung.com, gregkh@linuxfoundation.org,
        wfp5p@virginia.edu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ll_temac: Reset dma descriptors indexes on ndo_open
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380608230-29183-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1380608230-29183-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 01 Oct 2013 09:32:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue,  1 Oct 2013 08:17:10 +0200

> The dma descriptors indexes are only initialized on the probe function.
> 
> If a packet is on the buffer when temac_stop is called, the dma
> descriptors indexes can be left on a incorrect state where no other
> package can be sent.
> 
> So an interface could be left in an usable state after ifdow/ifup.
> 
> This patch makes sure that the descriptors indexes are in a proper
> status when the device is open.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Applied and queued up for -stable, thanks.
