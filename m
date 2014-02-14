Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaBNSqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:46:19 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:45427
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbaBNSqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:46:18 -0500
Date: Fri, 14 Feb 2014 12:46:16 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 6/9] slab: introduce alien_cache
In-Reply-To: <1392361043-22420-7-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.10.1402141245520.12887@nuc>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com> <1392361043-22420-7-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Joonsoo Kim wrote:

> Currently, we use array_cache for alien_cache. Although they are mostly
> similar, there is one difference, that is, need for spinlock.
> We don't need spinlock for array_cache itself, but to use array_cache for
> alien_cache, array_cache structure should have spinlock. This is needless
> overhead, so removing it would be better. This patch prepare it by
> introducing alien_cache and using it. In the following patch,
> we remove spinlock in array_cache.

Acked-by: Christoph Lameter <cl@linux.com>
