Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3JRPNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:13:36 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37041 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3JRPNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:13:35 -0400
MIME-Version: 1.0
In-Reply-To: <00000141c7d1fae0-ff132cb2-5485-4b8f-9b22-d4da27068681-000000@email.amazonses.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1381913052-23875-9-git-send-email-iamjoonsoo.kim@lge.com>
	<00000141c7d1fae0-ff132cb2-5485-4b8f-9b22-d4da27068681-000000@email.amazonses.com>
Date: Sat, 19 Oct 2013 00:13:34 +0900
Message-ID: <CAAmzW4PXifdn9YKG0YNmbS_Zn6-DsTqAiT5=_up2+jzTpz=8bw@mail.gmail.com>
Subject: Re: [PATCH v2 08/15] slab: use __GFP_COMP flag for allocating slab pages
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/18 Christoph Lameter <cl@linux.com>:
> On Wed, 16 Oct 2013, Joonsoo Kim wrote:
>
>> If we use 'struct page' of first page as 'struct slab', there is no
>> advantage not to use __GFP_COMP. So use __GFP_COMP flag for all the cases.
>
> Yes this is going to make the allocators behave in the same way. We could
> actually put some of the page allocator related functionality in
> slab_common.c

Okay. After merging this, I will try to clean-up that.

> Acked-by: Christoph Lameter <cl@linux.com>

Thanks.
