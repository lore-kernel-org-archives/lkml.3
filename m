Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3EFP3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:29:13 -0400
Received: from tex.lwn.net ([70.33.254.29]:46500 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab3EFP3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:29:12 -0400
Date: Mon, 6 May 2013 09:29:10 -0600
From: Jake Edge <jake@lwn.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
Message-ID: <20130506092910.080f96cd@chukar.edge2.net>
In-Reply-To: <1367853859.8434.11.camel@jlt4.sipsolutions.net>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
	<1367853112.8434.6.camel@jlt4.sipsolutions.net>
	<20130506092143.58a7713f@chukar.edge2.net>
	<1367853859.8434.11.camel@jlt4.sipsolutions.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.16; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 May 2013 17:24:19 +0200 Johannes Berg wrote:
> On Mon, 2013-05-06 at 09:21 -0600, Jake Edge wrote:
> 
> > > Thanks for the report. Is the AP on a passive channel by any
> > > chance (5 GHz, or channels 12/13)?
> > 
> > No, from what I can see on my router, it is using channel 36 (5.180
> > GHz) for the SSID in question
> 
> So yes, that is a passive channel for the 4965 device :-)

oops, sorry :)  (obviously I don't know what a passive channel is :)

> > but Stanislaw seems to have pinpointed the issue.
> 
> Yeah that was a workaround, but I'm not sure we'd really want to do
> that. I'd rather see what really caused this issue. I have a feeling
> it's the passive-no-RX workaround, or lack thereof maybe? I need to
> look a bit closer.

Ok, I'm happy to test things out at this end ... change channels on the
router, build new kernels, etc.

thanks,

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
