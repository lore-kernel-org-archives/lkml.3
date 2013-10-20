Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab3JTSFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 14:05:23 -0400
Received: from a9-99.smtp-out.amazonses.com ([54.240.9.99]:37323 "EHLO
	a9-99.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140Ab3JTSFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 14:05:22 -0400
Date: Sun, 20 Oct 2013 18:05:21 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: JoonSoo Kim <js1304@gmail.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 13/15] slab: use struct page for slab management
In-Reply-To: <CAAmzW4PsEfGR8TMDiP4LTX7Oj3nr+F4Pxo2DyOEV4ab1pPmwkw@mail.gmail.com>
Message-ID: <00000141d70af320-21d92853-2cfb-4292-af09-dd57d406ab8b-000000@email.amazonses.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com> <1381913052-23875-14-git-send-email-iamjoonsoo.kim@lge.com> <00000141c7d66282-aa92b1f2-2a69-424b-9498-8e5367304d32-000000@email.amazonses.com>
 <CAAmzW4PsEfGR8TMDiP4LTX7Oj3nr+F4Pxo2DyOEV4ab1pPmwkw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.20-54.240.9.99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Oct 2013, JoonSoo Kim wrote:

> I search the history of struct page and find that the SLUB use mapping field
> in past (2007 year). At that time, you inserted VM_BUG_ON(PageSlab(page))
> ('b5fab14') into page_mapping() function to find remaining use. Recently,
> I never hear that this is triggered and 6 years have passed since inserting
> VM_BUG_ON(), so I guess there is no problem to use it.
> If this argument is reasonable, please give me an ACK :)
>
> Thanks.

Acked-by: Christoph Lameter <cl@linux.com>

