Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaK1Rxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:53:45 -0500
Received: from mail.us.es ([193.147.175.20]:35393 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaK1Rxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:53:43 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus5 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19692. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 2.808835 secs); 28 Nov 2014 17:53:40 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Fri, 28 Nov 2014 18:55:53 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Cc: David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, sven@open-mesh.com
Subject: Re: [PATCH 1/1] bridge: Fix NAT66ed IPv6 packets not being bridged
 correctly
Message-ID: <20141128175553.GA7807@salvia>
References: <1410816448-4401-1-git-send-email-bernhard.thaler@wvnet.at>
 <20140915.174009.1151039353244879675.davem@davemloft.net>
 <20141003112119.GA5420@salvia>
 <54777AE6.7050102@wvnet.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54777AE6.7050102@wvnet.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 08:26:30PM +0100, Bernhard Thaler wrote:
> Hi,
> 
> I tested Sven's patch in my setup and I think it should be safe to use
> it. It is shorter and cleaner written and he submitted it earlier.

Thanks for testing.

> I will be happy to assist you or Sven if any further work is needed.

Please, resubmit this patch to netfilter-devel@vger.kernel.org.
Thanks.
