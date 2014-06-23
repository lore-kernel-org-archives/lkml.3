Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbaFWULt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:11:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34816 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWULp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:11:45 -0400
Date: Mon, 23 Jun 2014 13:11:44 -0700 (PDT)
Message-Id: <20140623.131144.199410086942856418.davem@davemloft.net>
To: greg@kroah.com
Cc: haiyangz@microsoft.com, olaf@aepfle.de, netdev@vger.kernel.org,
        jasowang@redhat.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140623162911.GA20715@kroah.com>
References: <20140623131723.GA7026@aepfle.de>
	<5fb9ddebb68d456ab87979b5cc3830ec@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<20140623162911.GA20715@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Jun 2014 13:11:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Mon, 23 Jun 2014 12:29:11 -0400

> Given that this change will fail on all future distro releases, and
> almost all of the community distros today, I don't see how this is
> acceptable at all.  Nor would it be any better if you switch to a
> systemd command line script as well.  You should just work like any
> other network device works in this situation when it comes to
> enabling/disabling the device.  Worse case, just tear down the whole
> network device at suspend time, and recreate it at resume.

Agreed, and I've strongly asked them to remove this code immediately.
