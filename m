Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaJTHvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:51:41 -0400
Received: from mail.us.es ([193.147.175.20]:34637 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbaJTHvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:51:38 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19522. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 2.494231 secs); 20 Oct 2014 07:51:35 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Mon, 20 Oct 2014 09:53:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20141020075307.GA3420@salvia>
References: <20141019.132314.264021750039480460.davem@davemloft.net>
 <CA+55aFz4UdVbZKPKwkesj0=1Yu7jLDP3Q3-jwe45b7gRU+0rog@mail.gmail.com>
 <20141019.210314.1388340101577924200.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141019.210314.1388340101577924200.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 09:03:14PM -0400, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sun, 19 Oct 2014 17:32:15 -0700
> 
> > Looks like the module license issue was just overlooked when moving
> > the code out in commit c8d7b98bec43 ("netfilter: move nf_send_resetX()
> > code to nf_reject_ipvX modules").
> 
> I think Pablo has a patch pending to address this, and indeed he does:
> 
> 	http://marc.info/?l=linux-netdev&m=141293491712312&w=2
> 
> Pablo please push this to me soon, thanks.

I'll send you this batch today. Thanks.
