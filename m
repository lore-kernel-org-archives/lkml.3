Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaAPSuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:50:01 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15039 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751616AbaAPSt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:49:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19PZMrMnfxuO40VHCrlw65FycKlOQcJXUI=
X-DKIM: OpenDKIM Filter v2.0.1 titan EFF1D50C214
Date: Thu, 16 Jan 2014 13:49:43 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Ian Campbell <ijc@hellion.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: orion: provide C-style interrupt handler for
 MULTI_IRQ_HANDLER
Message-ID: <20140116184943.GK29184@titan.lakedaemon.net>
References: <1389775235.10695.51.camel@dagon.hellion.org.uk>
 <1389859831-9883-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140116164833.GH29184@titan.lakedaemon.net>
 <1389891087.6697.26.camel@kazak.uk.xensource.com>
 <20140116165347.GI29184@titan.lakedaemon.net>
 <52D82802.6090104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D82802.6090104@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 07:42:10PM +0100, Sebastian Hesselbarth wrote:
...
> Out of curiosity, does that adding the Cc tag to the commit queue
> it automatically as soon as it will be pulled by Linus?

Yes.  The -stable team scans commits as they are added to Linus' tree.
If it has that tag, then they cherrypick it for the appropriate trees.
As do many vendors and distros.

There's no need to actually "email Cc" stable, they won't take it until
it's landed in mainline.  iirc, this generates a form letter from Greg
:)

> @Ian: Thanks for hunting this down, please keep bothering us with
> bug reports :)

Yes, please!

thx,

Jason.
