Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaCMTtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:49:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55773 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaCMTtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:49:00 -0400
Date: Thu, 13 Mar 2014 15:48:58 -0400 (EDT)
Message-Id: <20140313.154858.1537389952540665300.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: Ian.Campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jonathan.davies@citrix.com
Subject: Re: [PATCH net-next] xen-netback: Schedule NAPI from dealloc
 thread instead of callback
From: David Miller <davem@davemloft.net>
In-Reply-To: <5321D265.8070907@citrix.com>
References: <20140313101720.GA16807@zion.uk.xensource.com>
	<1394707350.25873.34.camel@kazak.uk.xensource.com>
	<5321D265.8070907@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Mar 2014 12:49:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Thu, 13 Mar 2014 15:44:37 +0000

> I've just discussed this with Ian, this solution still doesn't solve
> the racing between NAPI and the dealloc thread, however it only causes
> some unnecessary napi_schedule's, not ring stalls.
> There is a better solution, I'll post it as soon as it passes all the
> test!

Ok, I'm skipping this patch therefore.
