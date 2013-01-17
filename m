Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab3AQCFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:05:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42308 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab3AQCFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:05:16 -0500
Date: Wed, 16 Jan 2013 21:05:12 -0500 (EST)
Message-Id: <20130116.210512.2230612692562212911.davem@davemloft.net>
To: carlos@systemhalted.org
Cc: bhutchings@solarflare.com, yoshfuji@linux-ipv6.org, amwang@redhat.com,
        tmb@mageia.org, eblake@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, libvirt-list@redhat.com, tgraf@suug.ch,
        libc-alpha@sourceware.org, schwab@suse.de
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and
 <linux/in6.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <50F75AD7.7000703@systemhalted.org>
References: <1358351232.2923.10.camel@bwh-desktop.uk.solarflarecom.com>
	<20130116.164511.2027039182184636075.davem@davemloft.net>
	<50F75AD7.7000703@systemhalted.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos O'Donell <carlos@systemhalted.org>
Date: Wed, 16 Jan 2013 20:58:47 -0500

> So I just went down the rabbit hole, and the further I get the
> closer I get to having two exact copies of the same definitions
> in both glibc and the kernel and using whichever one was included
> first.
> 
> Is anyone opposed to that kind of solution?

Sounds interesting, please share :-)
