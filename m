Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaFJO0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:26:24 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:47891 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbaFJO0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:26:23 -0400
Date: Tue, 10 Jun 2014 09:26:19 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, akpm@linux-foundation.org,
        rientjes@google.com, penberg@kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2 8/8] slab: make dead memcg caches discard free
 slabs immediately
In-Reply-To: <20140610100313.GA6293@esperanza>
Message-ID: <alpine.DEB.2.10.1406100925270.17142@gentwo.org>
References: <cover.1402060096.git.vdavydov@parallels.com> <27a202c6084d6bb19cc3e417793f05104b908ded.1402060096.git.vdavydov@parallels.com> <20140610074317.GE19036@js1304-P5Q-DELUXE> <20140610100313.GA6293@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Vladimir Davydov wrote:

> Frankly, I incline to shrinking dead SLAB caches periodically from
> cache_reap too, because it looks neater and less intrusive to me. Also
> it has zero performance impact, which is nice.
>
> However, Christoph proposed to disable per cpu arrays for dead caches,
> similarly to SLUB, and I decided to give it a try, just to see the end
> code we'd have with it.
>
> I'm still not quite sure which way we should choose though...

Which one is cleaner?

