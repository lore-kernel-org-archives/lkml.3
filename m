Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab3FTXNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 19:13:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41142 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab3FTXNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 19:13:48 -0400
Date: Fri, 21 Jun 2013 01:13:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michal Simek <monstr@monstr.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] uio: Add two platform uio drivers to one
Message-ID: <20130620231346.GB1589@amd.pavel.ucw.cz>
References: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com>
 <71c482e15ee32fa304db73b984f6d5a63441cd92.1369317710.git.michal.simek@xilinx.com>
 <51A5E644.1040901@monstr.eu>
 <51AC8D43.100@monstr.eu>
 <20130603210513.GA22606@kroah.com>
 <20130620160126.GB22115@amd.pavel.ucw.cz>
 <51C337D7.1040404@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C337D7.1040404@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> can you please comment this?
> >>
> >> I'll let Hans handle this, as he's the UIO maintainer now.
> > 
> > Looks good to me.
> > 
> > Anyway, Hans disappeared, so Greg takes patches, again. Take a look,
> > it seems I already did some changes you wanted, they are in char-misc
> > tree.
> 
> Can you send me link to that repo?

I googled a mirror...

https://kernel.googlesource.com/pub/scm/linux/kernel/git/gregkh/char-misc/+/char-misc-next/drivers/uio/uio_pdrv_genirq.c
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
