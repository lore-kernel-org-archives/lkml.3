Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbaE3Oc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:32:56 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:52214 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504AbaE3Ocz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:32:55 -0400
Date: Fri, 30 May 2014 09:32:52 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 2/8] memcg: destroy kmem caches when last slab is
 freed
In-Reply-To: <ec6f290739074232ce1eeddc455ee14d471a70db.1401457502.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1405300932400.11943@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <ec6f290739074232ce1eeddc455ee14d471a70db.1401457502.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Vladimir Davydov wrote:

> When the memcg_cache_params->refcnt goes to 0, schedule the worker that
> will unregister the cache. To prevent this from happening when the owner
> memcg is alive, keep the refcnt incremented during memcg lifetime.

Acked-by: Christoph Lameter <cl@linux.com>

