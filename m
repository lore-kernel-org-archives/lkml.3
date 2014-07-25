Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbaGYNAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:00:48 -0400
Received: from mail.us.es ([193.147.175.20]:58611 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbaGYNAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:00:46 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19221. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-100.2/7.5):. 
 Processed in 1.773745 secs); 25 Jul 2014 13:00:45 -0000
X-Spam-ASN: AS42863 89.214.0.0/16
X-Envelope-From: pneira@us.es
Date: Fri, 25 Jul 2014 15:00:53 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] netfilter: nf_conntrack: remove exceptional & on
 function name
Message-ID: <20140725130053.GB13940@salvia>
References: <20140724201716.GA16213@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724201716.GA16213@himangi-Dell>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 01:47:16AM +0530, Himangi Saraogi wrote:
> In this file, function names are otherwise used as pointers without &.
> 
> A simplified version of the Coccinelle semantic patch that makes this
> change is as follows: 
> 
> // <smpl>
> @r@
> identifier f;
> @@
> 
> f(...) { ... }
> 
> @@
> identifier r.f;
> @@
> 
> - &f
> + f
> // </smpl>

Applied, thanks Himangi.
