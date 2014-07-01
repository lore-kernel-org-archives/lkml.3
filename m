Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342AbaGAWVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:21:39 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:46416 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047AbaGAWVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:21:24 -0400
Date: Tue, 1 Jul 2014 15:21:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3 2/9] slab: move up code to get kmem_cache_node in
 free_block()
In-Reply-To: <1404203258-8923-3-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.02.1407011520120.4004@chino.kir.corp.google.com>
References: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com> <1404203258-8923-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, Joonsoo Kim wrote:

> node isn't changed, so we don't need to retreive this structure
> everytime we move the object. Maybe compiler do this optimization,
> but making it explicitly is better.
> 

Qualifying the pointer as const would be even more explicit.

> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: David Rientjes <rientjes@google.com>
