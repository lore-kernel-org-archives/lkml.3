Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbaFWNsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:48:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32768 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbaFWNsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:48:30 -0400
Date: Mon, 23 Jun 2014 09:08:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Vrabel <david.vrabel@citrix.com>, Sarah Newman <srn@prgmr.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        Ingo Molnar <mingo@redhat.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM
 exception
Message-ID: <20140623130818.GA6772@laptop.dumpdata.com>
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>
 <531DEB11.2070709@zytor.com>
 <531DF319.6010800@citrix.com>
 <53266841.6090308@prgmr.com>
 <1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com>
 <53266D94.70902@prgmr.com>
 <53266F56.9030909@zytor.com>
 <5326F89F.8010404@citrix.com>
 <20140319132156.GA12574@phenom.dumpdata.com>
 <5329B17E.8060303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5329B17E.8060303@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 08:02:22AM -0700, H. Peter Anvin wrote:
> On 03/19/2014 06:21 AM, Konrad Rzeszutek Wilk wrote:
> >>
> >> The following patch does the always eager allocation.  It's a fixup of
> >> Suresh's original patch.
> >>
> > 
> > Hey Peter,
> > 
> > I think this is the solution you were looking for?
> > 
> > Or are there some other subtle issues that you think lurk around?
> > 
> 
> Ah, I managed to miss it (mostly because it was buried *inside* another
> email and didn't change the subject line... I really dislike that mode
> of delivering a patch.

Let me roll up some of these patchset and send them as git send-email.

> 
> Let me see if the issues have been fixed.  Still wondering if there is a
> way we can get away without the boot_func hack...

I have to confesss I don't even remember what the 'if the issues have been
fixed' is referring to?

> 
> 	-hpa
> 
> 
