Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3LCWMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:12:12 -0500
Received: from a9-112.smtp-out.amazonses.com ([54.240.9.112]:44740 "EHLO
	a9-112.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151Ab3LCWMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:12:08 -0500
X-Greylist: delayed 837 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 17:12:07 EST
Date: Tue, 3 Dec 2013 21:58:09 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Meelis Roos <mroos@linux.ee>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: Slab BUG with DEBUG_* options
In-Reply-To: <alpine.SOC.1.00.1312032314040.25191@math.ut.ee>
Message-ID: <00000142ba77e59d-3e002746-996d-4843-b8f1-51d1431b47a9-000000@email.amazonses.com>
References: <alpine.SOC.1.00.1311300125490.6363@math.ut.ee> <alpine.DEB.2.02.1312030930450.4115@gentwo.org> <00000142ba22e43b-99d8d7cb-9ecd-4f18-9609-8805270843d4-000000@email.amazonses.com> <alpine.SOC.1.00.1312032314040.25191@math.ut.ee>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.03-54.240.9.112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Meelis Roos wrote:

> Tested it. seems to hang after switching to another console. Before
> that, slabs are initialized successfully, I verified it with my previous
> debug printk sprinkle patch. Many allocations are still off slab - is
> that OK?

Yes that was the intend. Only exempt the small ones.

> console [tty0] enabled, bootconsole disabled

Looks like the bootstrap worked.

