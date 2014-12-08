Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaLHRIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:08:10 -0500
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:57175 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755865AbaLHRID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:08:03 -0500
Date: Mon, 8 Dec 2014 11:08:00 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] memcg: fix possible use-after-free in
 memcg_kmem_get_cache
In-Reply-To: <20141208152905.GA25542@esperanza>
Message-ID: <alpine.DEB.2.11.1412081107100.21477@gentwo.org>
References: <1417969947-4072-1-git-send-email-vdavydov@parallels.com> <alpine.DEB.2.11.1412080848240.21299@gentwo.org> <20141208152905.GA25542@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014, Vladimir Davydov wrote:

> Sounds reasonable, thanks. The updated patch is below.

Ok. SLAB also needs to have a similar hook scheme than SLUB at some point.

Acked-by: Christoph Lameter <cl@linux.com>
