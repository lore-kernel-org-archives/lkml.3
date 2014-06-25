Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaFYM4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:56:31 -0400
Received: from mail.us.es ([193.147.175.20]:52194 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaFYM43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:56:29 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus4 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19125. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-101.0/7.5):. 
 Processed in 1.821471 secs); 25 Jun 2014 12:56:28 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Wed, 25 Jun 2014 14:56:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] net/netfilter/nf_conntrack_netlink.c: remove null
 test before kfree
Message-ID: <20140625125620.GA10374@localhost>
References: <1403296738-6213-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403296738-6213-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:38:58PM +0200, Fabian Frederick wrote:
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required

Applied, thanks.
