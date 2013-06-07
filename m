Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3FGIEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:04:34 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48641 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3FGIE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:04:27 -0400
Date: Fri, 7 Jun 2013 09:02:39 +0100
From: Jamie Iles <jamie.iles@oracle.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Willy Tarreau <w@1wt.eu>, Jamie Iles <jamie.iles@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Lukas Czerner <lczerner@redhat.com>, dann frazier <dannf@debian.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 130/184] CVE-2012-4508 kernel: ext4: AIO vs fallocate stale
Message-ID: <20130607080239.GA10738@localhost>
References: <20130604172135.695967415@1wt.eu>
 <1370583725.4021.85.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370583725.4021.85.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, Willy,

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

That sounds correct to me - the patch is the result of splitting the 
large ext4 patch that RHEL did from 6.3 -> 6.4.  The Virtuozzo/OpenVZ 
folks came up with the same patch (independently I think) too.

> Would any of the above named be prepared to put their Signed-off-by to
> this?

Sure, I'd be happy to add my s-o-b.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Thanks,

Jamie
