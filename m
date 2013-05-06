Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab3EFPVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:21:46 -0400
Received: from tex.lwn.net ([70.33.254.29]:46450 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab3EFPVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:21:45 -0400
Date: Mon, 6 May 2013 09:21:43 -0600
From: Jake Edge <jake@lwn.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
Message-ID: <20130506092143.58a7713f@chukar.edge2.net>
In-Reply-To: <1367853112.8434.6.camel@jlt4.sipsolutions.net>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
	<1367853112.8434.6.camel@jlt4.sipsolutions.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.16; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 May 2013 17:11:52 +0200 Johannes Berg wrote:
> Hi Jake,
> 
> > commit 1672c0e31917f49d31d30d79067103432bc20cc7
> > Author: Johannes Berg <johannes.berg@intel.com>
> > Date:   Tue Jan 29 15:02:27 2013 +0100
> > 
> >     mac80211: start auth/assoc timeout on frame status
> > 
> > but I can't (easily) revert that in 3.9 (maybe I can in -rc1 or
> > something?  haven't tried that)
> > 
> > What more information is needed from me?  I may still mess around
> > with trying to revert that patch just to nail it down for sure, but
> > two separate bisection exercises ended up at the same place.
> 
> Thanks for the report. Is the AP on a passive channel by any chance (5
> GHz, or channels 12/13)?

No, from what I can see on my router, it is using channel 36 (5.180
GHz) for the SSID in question (and channel 11 2.462 GHz for the other
SSID) ... but Stanislaw seems to have pinpointed the issue.

thanks,

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
