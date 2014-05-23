Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaEWSuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:50:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54564 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaEWSuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:50:03 -0400
Date: Fri, 23 May 2014 14:50:01 -0400 (EDT)
Message-Id: <20140523.145001.2140056621716323006.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] Add hash value into RNDIS Per-packet info
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400702139-29280-1-git-send-email-haiyangz@microsoft.com>
References: <1400702139-29280-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 May 2014 11:50:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 21 May 2014 12:55:39 -0700

> It passes the hash value as the RNDIS Per-packet info to the Hyper-V host,
> so that the send completion notices can be spread across multiple channels.
> MS-TFS: 140273
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied, but please craft your Subject lines correctly in the future.

You did not specify a subsystem prefix, which in this case should
have been something like "hyperv: "

Otherwise people scanning the commit log headers have no idea where
your changes might be taking place.

I fixed it up this time for you.

Thanks.
