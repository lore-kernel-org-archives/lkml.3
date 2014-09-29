Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaI2Oh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:37:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33332 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaI2OhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:37:19 -0400
Date: Mon, 29 Sep 2014 16:36:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Yuri Gribov <tetra2005@gmail.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org,
        x86@kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 00/13] Kernel address sanitizer - runtime memory
 debugger.
Message-ID: <20140929143654.GN5430@worktop>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
 <54259BD4.8090508@oracle.com>
 <CACT4Y+Y0fzbs4DPt3n30R33cYqXEZ8E86tzCfzL6RUE9f+-r=w@mail.gmail.com>
 <CAPAsAGyDpnhpMquXi-K4wdDEbj-5W44uJLircsok7ziOO_m66g@mail.gmail.com>
 <CACT4Y+bptO341KQAQMSzUVV22KsjuomdTeDip=HaHJ3+1kvraQ@mail.gmail.com>
 <CAJOtW+7UJQ2=66vELbyfXumQ=c9LknRAzXmd6Z6ea7i4oy6FwA@mail.gmail.com>
 <CACT4Y+ZGXV_+J7sR-6_HX5eAOWQAXw5gSvjh1rw_mCxt90iNtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZGXV_+J7sR-6_HX5eAOWQAXw5gSvjh1rw_mCxt90iNtQ@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 06:22:46PM +0400, Dmitry Vyukov wrote:
> But on the second though... what do we want to do with pre-build
> modules? Can you envision that somebody distributes binary modules
> built with asan?

Nobody should ever care about binary modules other than inflicting the
maximum pain and breakage on whoever does so.
