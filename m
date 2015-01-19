Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbbASPmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:42:21 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:39391 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbASPmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:42:19 -0500
Date: Mon, 19 Jan 2015 10:42:15 -0500
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2 3/7] cgroup: release css->id after css_free
Message-ID: <20150119154215.GA10570@htj.dyndns.org>
References: <cover.1421664712.git.vdavydov@parallels.com>
 <4d7447a920522c1085ff96c08b2be71e0eb5d896.1421664712.git.vdavydov@parallels.com>
 <20150119143001.GH8140@htj.dyndns.org>
 <20150119151854.GA28598@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119151854.GA28598@esperanza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 06:18:54PM +0300, Vladimir Davydov wrote:
> Could you please elaborate this? I mean, what problems do you think can
> arise if we release css->id a little bit (one grace period) later?
> 
> Of course, I can introduce yet another id per memcg, but I think we have
> css->id to avoid code duplication in controllers.

lol, my brainfart.  Never mind.  I thought you were moving it to
offline.  Please feel free to add my acked-by.

Thanks.

-- 
tejun
