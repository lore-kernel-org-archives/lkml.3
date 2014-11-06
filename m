Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaKFLAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:00:12 -0500
Received: from mx2.parallels.com ([199.115.105.18]:45263 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKFLAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:00:10 -0500
Date: Thu, 6 Nov 2014 13:59:59 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 7/8] slab: introduce slab_free helper
Message-ID: <20141106105959.GD4839@esperanza>
References: <cover.1415046910.git.vdavydov@parallels.com>
 <439ae0a228e18af4ba909dce471a7e3d21005ef6.1415046910.git.vdavydov@parallels.com>
 <alpine.DEB.2.11.1411051241330.28485@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411051241330.28485@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 12:42:05PM -0600, Christoph Lameter wrote:
> Some comments would be good for the commit.

If it isn't too late, here it goes:

We have code duplication in kmem_cache_free/kfree. Let's move it to a
separate function.

> 
> Acked-by: Christoph Lameter <cl@linux.com>

Thank you.
