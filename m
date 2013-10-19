Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3JSWlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 18:41:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:40254 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab3JSWlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 18:41:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,531,1378882800"; 
   d="scan'208";a="377129027"
From: Andi Kleen <andi@firstfloor.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 00/15] slab: overload struct slab over struct page to reduce memory usage
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
Date: Sat, 19 Oct 2013 15:41:13 -0700
In-Reply-To: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
	(Joonsoo Kim's message of "Wed, 16 Oct 2013 17:43:57 +0900")
Message-ID: <87y55oubna.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> There is two main topics in this patchset. One is to reduce memory usage
> and the other is to change a management method of free objects of a slab.

I did a quick read over the whole patchset and it looks good to me. I
especially like how much code you remove. And of course the benchmarks
are looking good to. Thanks for cleaning up this old code.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
