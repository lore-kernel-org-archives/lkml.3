Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaJUPaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:30:03 -0400
Received: from mail.us.es ([193.147.175.20]:52599 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbaJUPaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:30:00 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19523. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 2.615995 secs); 21 Oct 2014 15:29:56 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Tue, 21 Oct 2014 17:31:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Feng Gao <gfree.wind@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, kadlec@blackhole.kfki.hu,
        davem@davemloft.net,
        Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: xt_hashlimit: Enhance the xt_hashlimit to
 avoid duplicated codes
Message-ID: <20141021153128.GA3657@salvia>
References: <CA+6hz4o-2vSEzH+hjYAUfWRVqHQ3QfcCr8q11eoRpCTq2uTYtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+6hz4o-2vSEzH+hjYAUfWRVqHQ3QfcCr8q11eoRpCTq2uTYtg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:23:16PM +0800, Feng Gao wrote:
> Hi all,
> 
> Enhance the functions "dsthash_alloc_init" and "hashlimit_mt" in file
> "xt_hashlimit.c" to avoid two duplicated codes following:
> 
> -           dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
> -           rateinfo_recalc(dh, now, hinfo->cfg.mode);
> 
> 
> The whole patch is following

The patch seems mangled by your MUA.

BTW, you can just Cc netfilter patches to
netfilter-devel@vger.kernel.org. No need to Cc that many people.

