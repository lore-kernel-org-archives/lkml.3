Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3IYUKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:10:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab3IYUKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:10:16 -0400
Date: Wed, 25 Sep 2013 16:09:50 -0400
From: Dave Jones <davej@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: Re: [PATCH] MAINTAINERS: wimax@linuxwimax.org is subscribers-only
Message-ID: <20130925200950.GA10751@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
References: <1380138892.17366.24.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380138892.17366.24.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 12:54:52PM -0700, Joe Perches wrote:
 > Mark it so.
 > 
 > Signed-off-by: Joe Perches <joe@perches.com>
 > ---
 >  MAINTAINERS | 4 ++--
 >  1 file changed, 2 insertions(+), 2 deletions(-)
 > 
 > diff --git a/MAINTAINERS b/MAINTAINERS
 > index e61c2e8..a386a22 100644
 > --- a/MAINTAINERS
 > +++ b/MAINTAINERS
 > @@ -4414,7 +4414,7 @@ F:	arch/x86/kernel/tboot.c
 >  INTEL WIRELESS WIMAX CONNECTION 2400
 >  M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 >  M:	linux-wimax@intel.com
 > -L:	wimax@linuxwimax.org
 > +L:	wimax@linuxwimax.org (subscribers-only)
 >  S:	Supported
 >  W:	http://linuxwimax.org
 >  F:	Documentation/wimax/README.i2400m
 > @@ -9225,7 +9225,7 @@ F:	drivers/media/rc/winbond-cir.c
 >  WIMAX STACK
 >  M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 >  M:	linux-wimax@intel.com
 > -L:	wimax@linuxwimax.org
 > +L:	wimax@linuxwimax.org (subscribers-only)
 >  S:	Supported
 >  W:	http://linuxwimax.org
 >  F:	Documentation/wimax/README.wimax

The W: link is dead. 

Given wimax never really took off, is there any point in keeping this in the kernel at all ?
We turned off the drivers in Fedora a while ago, and just threw out the userspace parts.
I wouldn't be surprised to learn of other distributions doing the same.

	Dave


