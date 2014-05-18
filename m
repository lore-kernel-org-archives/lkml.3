Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaERXP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 19:15:57 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19782 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaERXP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 19:15:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+5xwHdWG/ioPjzd/jjw1v9DAiK6zsYlQg=
X-DKIM: OpenDKIM Filter v2.0.1 titan E97D95791D5
Date: Sun, 18 May 2014 19:15:51 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jake Edge <jake@lwn.net>
Cc: Anton Saraev <antonysaraev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/1] staging/skein: rename files and clean up
 directory structure
Message-ID: <20140518231551.GZ27822@titan.lakedaemon.net>
References: <20140518125615.2df48ea9@chukar.edge2.net>
 <20140518225231.GW27822@titan.lakedaemon.net>
 <20140518170450.272a1381@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140518170450.272a1381@chukar.edge2.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 05:04:50PM -0600, Jake Edge wrote:
> On Sun, 18 May 2014 18:52:31 -0400 Jason Cooper wrote:
> 
> > Jake, would you mind dropping this patch and perhaps assisting me with
> > reviewing Anton's series?  I'll have him resend it as-is and we can go
> > from there.
> 
> No, that's fine.  Guess I'll put my patches to clean up some other
> stuff (function names, etc.) on hold and see how far Anton got ...
> 
> fwiw, I did look at the lists to see if someone had already been
> working on this stuff, which is why it is such a good idea make sure the
> patches get posted publicly ...

Yes, I agree.  It was a perfect storm of "Are my first patches good
enough for the mailinglist?", "Hey, Jason, thanks for taking on
drivers/irqchip", and "We need to get everything in before -rc6 for the
mvebu/arm-soc cutoff before the merge window".  Apparently, I'm not very
good at juggling three separate rushes at once. :)

Anton has the submission process down now, so from here on out he'll
just send them to the list.

Thanks for your understanding.

thx,

Jason.
