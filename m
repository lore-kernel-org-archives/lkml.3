Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab3APTAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 14:00:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37062 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3APTAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 14:00:03 -0500
Date: Wed, 16 Jan 2013 13:59:59 -0500 (EST)
Message-Id: <20130116.135959.90676245194307972.davem@davemloft.net>
To: vapier@gentoo.org
Cc: bhutchings@solarflare.com, libc-alpha@sourceware.org,
        yoshfuji@linux-ipv6.org, amwang@redhat.com, tmb@mageia.org,
        eblake@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, libvirt-list@redhat.com, tgraf@suug.ch,
        schwab@suse.de, carlos@systemhalted.org
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and
 <linux/in6.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <201301161228.42592.vapier@gentoo.org>
References: <201301161205.04502.vapier@gentoo.org>
	<1358356211.2923.25.camel@bwh-desktop.uk.solarflarecom.com>
	<201301161228.42592.vapier@gentoo.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 16 Jan 2013 12:28:39 -0500

> if you're not calling the kernel directly, why are you including the kernel 
> headers ?  what is the problem people are actually trying to address here (and 
> no, "i want to include both headers" is not the answer) ?

When GLIBC doesn't provide it's own definition of some networking
macros or interfaces that the kernel provides, people include the
kernel header.

This has been done for decades, wake up.
