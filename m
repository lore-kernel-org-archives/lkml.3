Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbaGASFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:05:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34371 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbaGASFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:05:13 -0400
Date: Tue, 01 Jul 2014 11:05:10 -0700 (PDT)
Message-Id: <20140701.110510.2218293817137911715.davem@davemloft.net>
To: edward.allcutt@openmarket.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: icmp: Fix pMTU handling for rare case
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.10.1407010937120.5997@tabini.allcutt.me.uk>
References: <1404141362-21015-1-git-send-email-edward.allcutt@openmarket.com>
	<20140630.234843.985671994258957329.davem@davemloft.net>
	<alpine.DEB.2.10.1407010937120.5997@tabini.allcutt.me.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Jul 2014 11:05:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edward Allcutt <edward.allcutt@openmarket.com>
Date: Tue, 1 Jul 2014 09:42:14 +0100 (BST)

> If it helps any, I've been running several production machines with
> this patch for just about a year now (mostly running 3.10 stable
> series).

I guess if OpenBSD can wait more than 2 decades to implement proper
path mtu handling, you can wait a year to post this bug fix :-)

I still think the OpenBSD thing can't be intentional, and it's some
bug they probably want to fix and it should therefore be investigated.
It means performance of connections going through such machines is
going to be crap even if I install your patch.

