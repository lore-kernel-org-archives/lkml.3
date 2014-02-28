Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaB1Izb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:55:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:49238 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaB1Iz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:55:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] bug: Make BUG() call unreachable()
Date: Fri, 28 Feb 2014 09:55:26 +0100
Message-ID: <6915585.VegnvotSUi@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140228001645.GA29605@thin>
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org> <201402272019.47554.arnd@arndb.de> <20140228001645.GA29605@thin>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vxPDm8fAseHNn96bX3jWp1MfYQBbDl0Cx24VTv1n2LK
 V0Wt8eiHzr8SIyIpq4zAFrIQB0XYGOXcf33CJWrLDs5hXjWwx9
 sPkom0z7Vh3+KhtDUU31VaArtF2WYeVps6bN6t7TilsLs90rZX
 m6BdvRyz63+ORSjI/wpPbayq7kvKunFZQYuqYJH6CLGZTSYp+c
 SzWLXWpFiWzg4hKK6GfpMIx/tPxsSEFIWNhAfpSW5ZNOkAaB2I
 iZVYJXVchz05/+zLQAs5Iheu5vaCQKUa6LYELLYemxZe+68OKS
 ZyYN8HVPQqunlALXz4nSfpp1Ct28Wmm0xPMhwNRlZo148jFlkI
 pPUuuvjzm/B9C2MsZH94=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 16:16:45 Josh Triplett wrote:
> On Thu, Feb 27, 2014 at 08:19:47PM +0100, Arnd Bergmann wrote:
> > On Wednesday 26 February 2014, Josh Triplett wrote:
> > > This doesn't seem any different than compiling out assert() at runtime
> > > in a userspace program, given how the kernel uses BUG() and BUG_ON().
> > > I'd argue that adding unreachable() doesn't seem like it makes the
> > > current implementation of BUG() any worse; either way if you reach it
> > > you have a problem.
> > 
> > I think it's better to get a warning about undefined behavior than
> > to suppress that warning.
> 
> Then at this point I'm going to suggest that you go ahead and submit the
> patch you want on top of the first four patches of this series.

Sure, no problem. I'll wait for your patches to show up in linux-next
and then do a patch on top. I'll be traveling for the next week, so
it may get delayed another few days.

> Please keep in mind the value and code size savings of !CONFIG_BUG, versus
> CONFIG_BUG=y and !CONFIG_DEBUG_BUGVERBOSE; those mean two different
> things.

I think I compared all the options before in the patch I cited,
https://lkml.org/lkml/2013/7/5/222 but I agree that the list
is a bit confusing.

> Meanwhile: Andrew, could you go ahead and apply the first four patches?

Yes please.

	Arnd
