Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaDNIix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:38:53 -0400
Received: from mail.us.es ([193.147.175.20]:44944 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbaDNIiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:38:50 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18790. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-101.2/7.5):. 
 Processed in 2.293039 secs); 14 Apr 2014 08:38:47 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Mon, 14 Apr 2014 10:38:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Miller <davem@davemloft.net>
Cc: avagin@openvz.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org, brouer@redhat.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu
Subject: Re: [PATCH] netfilter: conntrack: initialize net.ct.generation
Message-ID: <20140414083843.GA4553@localhost>
References: <1397237660-30632-1-git-send-email-avagin@openvz.org>
 <20140412.165818.1540640354445899640.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140412.165818.1540640354445899640.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 04:58:18PM -0400, David Miller wrote:
> From: Andrey Vagin <avagin@openvz.org>
> Date: Fri, 11 Apr 2014 21:34:20 +0400
> 
> > [  251.920788] INFO: trying to register non-static key.
> 
> I'll let Pablo integrate this.

Applied, thanks.
