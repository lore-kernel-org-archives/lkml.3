Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab3GVFP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 01:15:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49967 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756299Ab3GVFPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 01:15:54 -0400
Message-ID: <1374470152.2061.28.camel@joe-AO722>
Subject: Re: [PATCH 03/18] MAINTAINERS: OMAP POWERDOMAIN, update patterns
From: Joe Perches <joe@perches.com>
To: Paul Walmsley <paul@pwsan.com>, Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        cesarb@cesarb.net
Date: Sun, 21 Jul 2013 22:15:52 -0700
In-Reply-To: <alpine.DEB.2.02.1307220501390.4804@utopia.booyaka.com>
References: <cover.1374451988.git.joe@perches.com>
	 <8c1406e78f8536ff46ad9000b5634487243d5854.1374451988.git.joe@perches.com>
	 <alpine.DEB.2.02.1307220501390.4804@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 05:03 +0000, Paul Walmsley wrote:
> On Sun, 21 Jul 2013, Joe Perches wrote:
> 
> > commit 498153995b9 ("ARM: OMAP2+: powerdomain/PRM: move the
> > low-level powerdomain") renamed the files, update the patterns.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > cc: Paul Walmsley <paul@pwsan.com>
> > cc: Rajendra Nayak <rnayak@ti.com>
> > cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> I don't object to the content of this patch, but Cesar 
> Eduardo Barros posted a patch for this already (and cc'ed you) back 
> in March:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/1303.0/00904.html
> 
> The regex used in his pattern is also more accurate.  Please take his 
> patch instead, or credit him in your patch and use the cm*.[ch]/prm*.[ch] 
> notation from his patch.

(cc'ing Cesar)

Hi Paul.

I'm not the MAINTAINERS maintainer and I don't
pick up patches.

I certainly don't object at all if Andrew picks
up the patches you mentioned and drops these 2.

Andrew, here are links to Cesar's original patches
https://patchwork.kernel.org/project/LKML/list/?submitter=3513
https://lkml.org/lkml/2013/3/2/185

It seems a few are similar/duplicated to these 18.

Cesar, maybe you should resend yours.  I thought
they were applied and forgot all about them.

cheers, Joe

