Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaFFOsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:48:24 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:44577
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbaFFOsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:48:23 -0400
Date: Fri, 6 Jun 2014 09:48:20 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2 7/8] slub: make dead memcg caches discard free
 slabs immediately
In-Reply-To: <3b53266b76556dd042bbf6147207c70473572a7e.1402060096.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1406060948040.32229@gentwo.org>
References: <cover.1402060096.git.vdavydov@parallels.com> <3b53266b76556dd042bbf6147207c70473572a7e.1402060096.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Vladimir Davydov wrote:

> Since a dead memcg cache is destroyed only after the last slab allocated
> to it is freed, we must disable caching of empty slabs for such caches,
> otherwise they will be hanging around forever.

Acked-by: Christoph Lameter <cl@linux.com>
