Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbaFWUKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:10:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34801 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:10:19 -0400
Date: Mon, 23 Jun 2014 13:10:18 -0700 (PDT)
Message-Id: <20140623.131018.1349792926453695313.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: olaf@aepfle.de, greg@kroah.com, netdev@vger.kernel.org,
        jasowang@redhat.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
From: David Miller <davem@davemloft.net>
In-Reply-To: <5fb9ddebb68d456ab87979b5cc3830ec@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <06b508cbb6b949f4b3e13e7797948e56@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<20140623131723.GA7026@aepfle.de>
	<5fb9ddebb68d456ab87979b5cc3830ec@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Jun 2014 13:10:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon, 23 Jun 2014 16:09:59 +0000

> So, what's the equivalent or similar command to "network restart" on SLES12? Could
> you update the command line for the usermodehelper when porting this patch to SLES
> 12?

No, you are not going to keep the usermodehelper invocation in your driver
please remove it.  It is absolutely inappropriate, and I strictly do not want
to keep it in there because other people will copy it and then we'll have a
real mess on our hands.

