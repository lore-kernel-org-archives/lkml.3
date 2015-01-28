Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbbA2B4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:56:15 -0500
Received: from mx2.parallels.com ([199.115.105.18]:34994 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618AbbA2Bzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:55:49 -0500
Date: Wed, 28 Jan 2015 18:00:25 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/3] slub: don't fail kmem_cache_shrink if slab
 placement optimization fails
Message-ID: <20150128150025.GA11463@esperanza>
References: <cover.1422275084.git.vdavydov@parallels.com>
 <3804a429071f939e6b4f654b6c6426c1fdd95f7e.1422275084.git.vdavydov@parallels.com>
 <alpine.DEB.2.11.1501260944550.15849@gentwo.org>
 <20150126170147.GB28978@esperanza>
 <alpine.DEB.2.11.1501261216120.16638@gentwo.org>
 <20150126193629.GA2660@esperanza>
 <alpine.DEB.2.11.1501261353020.16786@gentwo.org>
 <20150127125838.GD5165@esperanza>
 <alpine.DEB.2.11.1501271100520.25124@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501271100520.25124@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 11:02:12AM -0600, Christoph Lameter wrote:
> What you could do is simply put all slab pages with more than 32 objects
> available at the end of the list.

OK, got it, will redo. Thanks!
