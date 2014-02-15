Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaBOA0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 19:26:19 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:56808 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397AbaBOA0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 19:26:18 -0500
Date: Fri, 14 Feb 2014 18:26:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: David Rientjes <rientjes@google.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 2/9] slab: makes clear_obj_pfmemalloc() just return store
 masked value
In-Reply-To: <alpine.DEB.2.02.1402141516540.13935@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.10.1402141824300.5204@nuc>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com> <1392361043-22420-3-git-send-email-iamjoonsoo.kim@lge.com> <alpine.DEB.2.10.1402141225460.12887@nuc> <alpine.DEB.2.02.1402141516540.13935@chino.kir.corp.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, David Rientjes wrote:

> Yeah, you don't need it, but don't you think it makes the code more
> readable?  Otherwise this is going to be just doing
>
> 	return (unsigned long)objp & ~SLAB_OBJ_PFMEMALLOC;
>
> and you gotta figure out the function type to understand it's returned as

Isnt there something like PTR_ALIGN() for this case that would make it
more readable?

