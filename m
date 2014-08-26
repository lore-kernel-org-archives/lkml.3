Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaHZVXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:23:18 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:40566 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbaHZVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:23:17 -0400
Date: Tue, 26 Aug 2014 16:23:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/slab_common: commonize slab merge logic
In-Reply-To: <20140826022359.GB1035@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.11.1408261622420.4609@gentwo.org>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com> <1408608675-20420-2-git-send-email-iamjoonsoo.kim@lge.com> <alpine.DEB.2.11.1408251026110.27302@gentwo.org> <20140826022359.GB1035@js1304-P5Q-DELUXE>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Joonsoo Kim wrote:

> On Mon, Aug 25, 2014 at 10:27:58AM -0500, Christoph Lameter wrote:
> > Uhh.. You would have to specify "slub_nomerge" to get slab to not merge
> > slab caches?
>
> Should fix it. How about following change?
>
> #ifdef CONFIG_SLUB
> __setup("slub_nomerge", setup_slab_nomerge);
> #endif
>
> __setup("slab_nomerge", setup_slab_nomerge);
>
> This makes "slab_nomerge" works for all SL[aou]B.

Ok. At some point we need to make slub_nomerge legacy then.

