Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030414AbaLLPHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:07:22 -0500
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:45841 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030379AbaLLPHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:07:21 -0500
Date: Fri, 12 Dec 2014 09:07:18 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] memcg: zap memcg_slab_caches and memcg_slab_mutex
In-Reply-To: <1418388362-11221-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1412120906540.6272@gentwo.org>
References: <1418388362-11221-1-git-send-email-vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As far as I can see for the slab_common.c part this is ok

Acked-by: Christoph Lameter <cl@linux.com>


