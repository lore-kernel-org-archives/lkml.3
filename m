Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3GVFD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 01:03:29 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:42245 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3GVFD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 01:03:28 -0400
Date: Mon, 22 Jul 2013 05:03:27 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        cesarb@cesarb.net
Subject: Re: [PATCH 03/18] MAINTAINERS: OMAP POWERDOMAIN, update patterns
In-Reply-To: <8c1406e78f8536ff46ad9000b5634487243d5854.1374451988.git.joe@perches.com>
Message-ID: <alpine.DEB.2.02.1307220501390.4804@utopia.booyaka.com>
References: <cover.1374451988.git.joe@perches.com> <8c1406e78f8536ff46ad9000b5634487243d5854.1374451988.git.joe@perches.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jul 2013, Joe Perches wrote:

> commit 498153995b9 ("ARM: OMAP2+: powerdomain/PRM: move the
> low-level powerdomain") renamed the files, update the patterns.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Paul Walmsley <paul@pwsan.com>
> cc: Rajendra Nayak <rnayak@ti.com>
> cc: Santosh Shilimkar <santosh.shilimkar@ti.com>

I don't object to the content of this patch, but Cesar 
Eduardo Barros posted a patch for this already (and cc'ed you) back 
in March:

http://lkml.indiana.edu/hypermail/linux/kernel/1303.0/00904.html

The regex used in his pattern is also more accurate.  Please take his 
patch instead, or credit him in your patch and use the cm*.[ch]/prm*.[ch] 
notation from his patch.


- Paul
