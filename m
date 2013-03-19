Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188Ab3CSIHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:07:07 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47345 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933679Ab3CSIHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:07:02 -0400
X-AuditID: 9c93016f-b7bfaae000003db8-88-51481ca316c1
Date: Tue, 19 Mar 2013 17:07:21 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 1/3] mm, nobootmem: fix wrong usage of max_low_pfn
Message-ID: <20130319080721.GI8858@lge.com>
References: <1363670161-9214-1-git-send-email-iamjoonsoo.kim@lge.com>
 <CAE9FiQWXYGdAp82HE8Jg=HYdxWa5nPC5g63E6rNNwYyAQ-B5tg@mail.gmail.com>
 <20130319062522.GG8858@lge.com>
 <20130319064247.GH8858@lge.com>
 <CAE9FiQV=NWCgbV=AT1W6Y5a0jH+tk5Oi6dSDZ2XQoPgCoYZ8Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQV=NWCgbV=AT1W6Y5a0jH+tk5Oi6dSDZ2XQoPgCoYZ8Cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 12:35:45AM -0700, Yinghai Lu wrote:
> Can you check why sparc do not need to change interface during converting
> to use memblock to replace bootmem?

Sure.
According to my understanding to sparc32 code(arch/sparc/mm/init_32.c),
they already use max_low_pfn as the maximum PFN value,
not as the number of pages.

