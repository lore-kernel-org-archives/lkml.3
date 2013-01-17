Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab3AQHD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 02:03:27 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:56451 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745Ab3AQHDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 02:03:25 -0500
Date: Thu, 17 Jan 2013 02:02:25 -0500 (EST)
From: Cong Wang <amwang@redhat.com>
To: Jike Song <albcamus@gmail.com>
Cc: David Miller <davem@davemloft.net>, vapier@gentoo.org,
        bhutchings@solarflare.com, libc-alpha@sourceware.org,
        yoshfuji@linux-ipv6.org, tmb@mageia.org, eblake@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvirt-list@redhat.com, tgraf@suug.ch, schwab@suse.de,
        carlos@systemhalted.org
Message-ID: <1893156080.7362411.1358406145231.JavaMail.root@redhat.com>
In-Reply-To: <1358405953.2547.3.camel@cr0>
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and
 <linux/in6.h>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.114.56]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> 
> I see no reason, even although I don't know why it is 46 instead of
> 40.

Ok, for "0000:0000:0000:0000:0000:0000:255.255.255.255".
