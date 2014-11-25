Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbaKYPyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:54:35 -0500
Received: from mail.us.es ([193.147.175.20]:44286 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaKYPyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:54:33 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19679. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 1.834646 secs); 25 Nov 2014 15:54:30 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Tue, 25 Nov 2014 16:56:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Subject: Re: linux-next: manual merge of the net-next tree with the vfs tree
Message-ID: <20141125155641.GA3817@salvia>
References: <20141125134246.2761ada5@canb.auug.org.au>
 <547466C8.1000203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547466C8.1000203@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 09:23:52AM -0200, Marcelo Ricardo Leitner wrote:
> On 25-11-2014 00:42, Stephen Rothwell wrote:
> >Hi all,
> >
> >Today's linux-next merge of the net-next tree got a conflict in
> >net/netfilter/nf_log.c between commit e71456ae9871 ("netfilter: Remove
> >checks of seq_printf() return values") from the vfs tree and commit
> >0c26ed1c07f1 ("netfilter: nf_log: Introduce nft_log_dereference()
> >macro") from the net-next tree.
> >
> >I fixed it up (see below) and can carry the fix as necessary (no action
> >is required).
> >
> 
> Looks good to me, thanks Stephen.

Also to me, thanks Stephen and Marcelo.
