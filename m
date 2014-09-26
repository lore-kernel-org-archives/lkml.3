Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbaIZRde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:33:34 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:62172 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbaIZRdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:33:33 -0400
MIME-Version: 1.0
In-Reply-To: <CACT4Y+bTXPzYH+TMjM9-NyVajZms8zKdEMMLDPvOKvRSoD8tog@mail.gmail.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
	<1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
	<1411562649-28231-14-git-send-email-a.ryabinin@samsung.com>
	<CACT4Y+bTXPzYH+TMjM9-NyVajZms8zKdEMMLDPvOKvRSoD8tog@mail.gmail.com>
Date: Fri, 26 Sep 2014 21:33:32 +0400
Message-ID: <CAPAsAGzDWQ6LKN1RN6u0cv6eTVfxgRT6NCpGA08dC6dnDiUKmA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 13/13] kasan: introduce inline instrumentation
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-26 21:18 GMT+04:00 Dmitry Vyukov <dvyukov@google.com>:
>
> Yikes!
> So this works during bootstrap, for user memory accesses, valloc
> memory, etc, right?
>

Yes, this works. Userspace memory access in instrumented code will
produce general protection fault,
so it won't be unnoticed.


-- 
Best regards,
Andrey Ryabinin
