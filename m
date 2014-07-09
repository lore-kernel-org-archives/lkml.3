Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbaGITee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:34:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:50963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaGITeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:34:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,632,1400050800"; 
   d="scan'208";a="567528100"
From: Andi Kleen <andi@firstfloor.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
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
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 05/21] x86: cpu: don't sanitize early stages of a secondary CPU boot
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
	<1404905415-9046-6-git-send-email-a.ryabinin@samsung.com>
Date: Wed, 09 Jul 2014 12:33:16 -0700
In-Reply-To: <1404905415-9046-6-git-send-email-a.ryabinin@samsung.com> (Andrey
	Ryabinin's message of "Wed, 09 Jul 2014 15:29:59 +0400")
Message-ID: <87egxunx8j.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Ryabinin <a.ryabinin@samsung.com> writes:

> Instrumentation of this files may result in unbootable machine.

This doesn't make sense. Is the code not NMI safe? 
If yes that would need to be fixed because

Please debug more.

perf is a common source of bugs (see Vice Weaver's fuzzer results),
so it would be good to have this functionality for it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
