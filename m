Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaLWNTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:19:39 -0500
Received: from mail.us.es ([193.147.175.20]:60661 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbaLWNTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:19:36 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.5/19827. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 4.804452 secs); 23 Dec 2014 13:19:35 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Tue, 23 Dec 2014 14:22:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Joe Perches <joe@perches.com>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH netfilter-next] xt_osf: Use continue to reduce indentation
Message-ID: <20141223132208.GB5369@salvia>
References: <1418761033.14140.5.camel@perches.com>
 <8632531418806285@web23h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8632531418806285@web23h.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 11:51:25AM +0300, Evgeniy Polyakov wrote:
> Hi everyone
> 
> 16.12.2014, 23:17, "Joe Perches" <joe@perches.com>:
> > Invert logic in test to use continue.
> >
> > This routine already uses continue, use it a bit more to
> > minimize > 80 column long lines and unnecessary indentation.
> >
> > No change in compiled object file.
> 
> Looks good. Thank you.
> Which tree should this patch go through? Please pull it in.
> 
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Applied to nf-next, thanks.
