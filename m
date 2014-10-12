Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaJLRn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 13:43:58 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:56163 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaJLRn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 13:43:57 -0400
MIME-Version: 1.0
In-Reply-To: <20141012.133047.427141450441745027.davem@davemloft.net>
References: <20141011.221510.1574777235900788349.davem@davemloft.net>
	<CAAmzW4Nrzp8TKurmevqmAV5kVRP2af1wZKqYcYH9RXroTZavpw@mail.gmail.com>
	<20141012.133047.427141450441745027.davem@davemloft.net>
Date: Mon, 13 Oct 2014 02:43:57 +0900
Message-ID: <CAAmzW4Pc=i9zHh5133Zc1rDRM1vaot18xXYwoMk8tTGtttwFgw@mail.gmail.com>
Subject: Re: unaligned accesses in SLAB etc.
From: Joonsoo Kim <js1304@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-13 2:30 GMT+09:00 David Miller <davem@davemloft.net>:
> From: Joonsoo Kim <js1304@gmail.com>
> Date: Mon, 13 Oct 2014 02:22:15 +0900
>
>> Could you test below patch?
>> If it fixes your problem, I will send it with proper description.
>
> It works, I just tested using ARCH_KMALLOC_MINALIGN which would be
> better.

Oops. resend with whole Cc list.

Thanks for testing.
ARCH_KMALLOC_MINALIGN is for object alignment,
but, current problem is caused by alignment of cpu cache array.
I think that my fix is more proper in this situation.
I will send fix tomorrow,
because I'd like to test more and it's 2:42 am. :)

Thanks.
