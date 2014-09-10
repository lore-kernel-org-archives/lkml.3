Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaIJUcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:32:36 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:45827 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaIJUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:32:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1409101116160.1654@gentwo.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
	<1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
	<1410359487-31938-5-git-send-email-a.ryabinin@samsung.com>
	<alpine.DEB.2.11.1409101116160.1654@gentwo.org>
Date: Thu, 11 Sep 2014 00:32:34 +0400
Message-ID: <CAPAsAGxuoXEM2AXRV_at0=xiLOmaZe+QY-45KeA7ZvvHzhOqMg@mail.gmail.com>
Subject: Re: [RFC/PATCH v2 04/10] mm: slub: introduce virt_to_obj function.
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-10 20:16 GMT+04:00 Christoph Lameter <cl@linux.com>:
> On Wed, 10 Sep 2014, Andrey Ryabinin wrote:
>
>> virt_to_obj takes kmem_cache address, address of slab page,
>> address x pointing somewhere inside slab object,
>> and returns address of the begging of object.
>
> This function is SLUB specific. Does it really need to be in slab.h?
>

Oh, yes this should be in slub.c

-- 
Best regards,
Andrey Ryabinin
