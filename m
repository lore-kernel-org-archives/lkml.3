Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaGJADW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:03:22 -0400
Received: from one.firstfloor.org ([193.170.194.197]:40322 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaGJADU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:03:20 -0400
Date: Thu, 10 Jul 2014 02:03:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Hansen <dave.hansen@intel.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kbuild <linux-kbuild@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, x86 maintainers <x86@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [RFC/PATCH RESEND -next 00/21] Address sanitizer for kernel
 (kasan) - dynamic memory error detector.
Message-ID: <20140710000318.GO18735@two.firstfloor.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <53BDB1D6.1090605@intel.com>
 <8761j6nr53.fsf@tassilo.jf.intel.com>
 <CAOMGZ=Fmqg6MWyx3NygqVmYiqw=npkPQrO9ifhF489bq5Gxz4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMGZ=Fmqg6MWyx3NygqVmYiqw=npkPQrO9ifhF489bq5Gxz4A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FWIW, I definitely agree with this -- if KASAN can do everything that
> kmemcheck can, it is no doubt the right way forward.

Thanks

BTW I didn't want to sound like I'm against kmemcheck. It is a very
useful tool and was impressive work given the constraints (no help from
the compiler)

-andi
