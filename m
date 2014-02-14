Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaBNRAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:00:39 -0500
Received: from mail.us.es ([193.147.175.20]:33738 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbaBNRAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:00:37 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus3 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18474. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-100.8/7.5):. 
 Processed in 1.920973 secs); 14 Feb 2014 17:00:35 -0000
X-Spam-ASN: AS8881 62.217.32.0/19
X-Envelope-From: pneira@us.es
Date: Fri, 14 Feb 2014 18:00:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Weinberger <richard@nod.at>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_meta: fix typo "CONFIG_NET_CLS_ROUTE"
Message-ID: <20140214170031.GB7415@localhost>
References: <1392198781.23759.15.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392198781.23759.15.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:53:01AM +0100, Paul Bolle wrote:
> There are two checks for CONFIG_NET_CLS_ROUTE, but the corresponding
> Kconfig symbol was dropped in v2.6.39. Since the code guards access to
> dst_entry.tclassid it seems CONFIG_IP_ROUTE_CLASSID should be used
> instead.

Applied, thanks.
