Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3CSXMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:12:30 -0400
Received: from mail.us.es ([193.147.175.20]:37029 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab3CSXM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:12:28 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus3 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.6/16875. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-94.9/7.5):. 
 Processed in 1.719598 secs); 19 Mar 2013 23:12:26 -0000
X-Envelope-From: pneira@us.es
Date: Wed, 20 Mar 2013 00:12:23 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: remove unused "config IP_NF_QUEUE"
Message-ID: <20130319231223.GA4017@localhost>
References: <1363734599.1390.50.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363734599.1390.50.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 12:09:59AM +0100, Paul Bolle wrote:
> Kconfig symbol IP_NF_QUEUE is unused since commit
> d16cf20e2f2f13411eece7f7fb72c17d141c4a84 ("netfilter: remove ip_queue
> support"). Let's remove it too.

Applied, thanks for catching up this leftover.
