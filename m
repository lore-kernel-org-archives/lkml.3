Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbaIZRoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:44:10 -0400
Received: from mail.us.es ([193.147.175.20]:48330 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbaIZRoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:44:08 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus6 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19441. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-101.4/7.5):. 
 Processed in 2.434087 secs); 26 Sep 2014 17:44:05 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Fri, 26 Sep 2014 19:45:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: akpm@linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz
Subject: Re: mmotm 2014-09-25-16-28 uploaded (nf_nat_masquerade_ipv4.c)
Message-ID: <20140926174517.GA11463@salvia>
References: <5424a53b.o+nym6SX0Tg7EdW6%akpm@linux-foundation.org>
 <54259A5C.2060102@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54259A5C.2060102@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Fri, Sep 26, 2014 at 09:54:52AM -0700, Randy Dunlap wrote:
> On 09/25/14 16:28, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2014-09-25-16-28 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> 
> ../net/ipv4/netfilter/nf_nat_masquerade_ipv4.c: In function 'nf_nat_masquerade_ipv4':
> ../net/ipv4/netfilter/nf_nat_masquerade_ipv4.c:59:5: error: 'struct nf_conn_nat' has no member named 'masq_index'
>   nat->masq_index = out->ifindex;
>      ^
> ../net/ipv4/netfilter/nf_nat_masquerade_ipv4.c: In function 'device_cmp':
> ../net/ipv4/netfilter/nf_nat_masquerade_ipv4.c:83:12: error: 'const struct nf_conn_nat' has no member named 'masq_index'
>   return nat->masq_index == (int)(long)ifindex;
>             ^
> ../net/ipv4/netfilter/nf_nat_masquerade_ipv4.c:84:1: warning: control reaches end of non-void function [-Wreturn-type]

I'll pass this patch in the upcoming nf-next batch:

http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/commit/?id=67981fefb20e717cea55b42f9081a833fa46b3be

Thanks.
