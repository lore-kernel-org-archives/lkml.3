Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaCMNOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:14:04 -0400
Received: from mail.us.es ([193.147.175.20]:40912 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaCMNOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:14:01 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18586. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-97.6/7.5):. 
 Processed in 1.911429 secs); 13 Mar 2014 13:13:59 -0000
X-Spam-ASN: AS12715 188.78.0.0/16
X-Envelope-From: pneira@us.es
Date: Thu, 13 Mar 2014 14:13:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, netdev@vger.kernel.org, kaber@trash.net,
        kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] netfilter: Convert uses of __constant_<foo>
 to <foo>
Message-ID: <20140313131356.GA5954@localhost>
References: <cover.1394643455.git.joe@perches.com>
 <d0259d9122d308e3297cac6f7bc47c9955c3597b.1394643455.git.joe@perches.com>
 <20140312.152855.298436374579216260.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312.152855.298436374579216260.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 03:28:55PM -0400, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Wed, 12 Mar 2014 10:04:19 -0700
> 
> > The use of __constant_<foo> has been unnecessary for quite awhile now.
> > 
> > Make these uses consistent with the rest of the kernel.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Will let the netfilter folks pick this up.

Applied, thanks!
