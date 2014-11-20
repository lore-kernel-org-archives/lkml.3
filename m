Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaKTMOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:14:12 -0500
Received: from mail.us.es ([193.147.175.20]:33093 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbaKTMOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:14:06 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19655. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 4.907618 secs); 20 Nov 2014 12:14:05 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Thu, 20 Nov 2014 13:16:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Patrick McHardy <kaber@trash.net>,
        Wensong Zhang <wensong@linux-vs.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] netfilter: Deletion of unnecessary checks before two
 function calls
Message-ID: <20141120121608.GA10093@salvia>
References: <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <546BA253.6030100@users.sourceforge.net>
 <alpine.LFD.2.11.1411200024280.6497@ja.home.ssi.bg>
 <20141120011359.GJ5065@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120011359.GJ5065@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:13:59AM +0900, Simon Horman wrote:
> On Thu, Nov 20, 2014 at 12:26:56AM +0200, Julian Anastasov wrote:
> > 
> > 	Hello,
> > 
> > On Tue, 18 Nov 2014, SF Markus Elfring wrote:
> > 
> > > From: Markus Elfring <elfring@users.sourceforge.net>
> > > Date: Tue, 18 Nov 2014 20:37:05 +0100
> > > 
> > > The functions free_percpu() and module_put() test whether their argument
> > > is NULL and then return immediately. Thus the test around the call is
> > > not needed.
> > > 
> > > This issue was detected by using the Coccinelle software.
> > > 
> > > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > 
> > 	Pablo, the IPVS parts look ok to me,
> > 
> > Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> Acked-by: Simon Horman <horms@verge.net.au>

Applied, thanks.
