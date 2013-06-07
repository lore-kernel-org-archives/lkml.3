Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab3FGFxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:53:52 -0400
Received: from 1wt.eu ([62.212.114.60]:36125 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3FGFxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:53:50 -0400
Date: Fri, 7 Jun 2013 07:53:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jamie Iles <jamie.iles@oracle.com>, Dmitry Monakhov <dmonakhov@openvz.org>,
        Lukas Czerner <lczerner@redhat.com>, dann frazier <dannf@debian.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 130/184] CVE-2012-4508 kernel: ext4: AIO vs fallocate stale
Message-ID: <20130607055338.GM14633@1wt.eu>
References: <20130604172135.695967415@1wt.eu> <1370583725.4021.85.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370583725.4021.85.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 06:42:05AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> >  data exposure
> > 
> > From: Jamie Iles <jamie.iles@oracle.com>
> > 
> > CVE-2012-4508 kernel: ext4: AIO vs fallocate stale data exposure
> > [dannf: backported to Debian's 2.6.32]
> 
> Well, this has an interesting ancestry.  The original upstream commits
> were c278531d39f3158bfee93dc67da0b77e09776de2,
> 60d4616f3dc63371b3dc367e5e88fd4b4f037f65 and (most importantly)
> dee1f973ca341c266229faa5a1a5bb268bed3531 by Dmitry Monakhov
> <dmonakhov@openvz.org>.  They were backported into the RHEL 6 kernel by
> Lukas Czerner, according to its changelog.  Dann got this version from
> Oracle's redpatch repository, where, if I understand rightly, Jamie Iles
> attempted to regenerate Lukas's patch(es).
> 
> Would any of the above named be prepared to put their Signed-off-by to
> this?

Interesting archaeological digging. In the mean time I'm adding this
useful information to the message commit, it never hurts and can be
useful in the future.

Guys, I'm planning on releasing this late this evening on European
time, so it's not too late yet to add your s-o-b.

Thanks,
Willy

