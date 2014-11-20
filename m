Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbaKTXPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:15:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:53654 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbaKTXPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:15:11 -0500
Date: Fri, 21 Nov 2014 00:14:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dmitry Vyukov <dvyukov@google.com>, Ingo Molnar <mingo@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v6 00/11] Kernel address sanitizer - runtime memory
 debugger.
In-Reply-To: <20141120150033.4cd1ca25be4a9b00a7074149@linux-foundation.org>
Message-ID: <alpine.DEB.2.11.1411210011530.6439@nanos>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com> <5461B906.1040803@samsung.com> <20141118125843.434c216540def495d50f3a45@linux-foundation.org> <CAPAsAGwZtfzx5oM73bOi_kw5BqXrwGd_xmt=m6xxU6uECA+H9Q@mail.gmail.com>
 <20141120090356.GA6690@gmail.com> <CACT4Y+aOKzq0AzvSJrRC-iU9LmmtLzxY=pxzu8f4oT-OZk=oLA@mail.gmail.com> <20141120150033.4cd1ca25be4a9b00a7074149@linux-foundation.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Andrew Morton wrote:

> On Thu, 20 Nov 2014 20:32:30 +0400 Dmitry Vyukov <dvyukov@google.com> wrote:
> 
> > Let me provide some background first.
> 
> Well that was useful.  Andrey, please slurp Dmitry's info into the 0/n
> changelog?

And into Documentation/UBSan or whatever the favourite place is. 0/n
lengthy explanations have a tendecy to be hard to retrieve.

Thanks,

	tglx


