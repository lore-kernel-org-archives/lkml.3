Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaGIUlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:41:04 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50602 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaGIUlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:41:00 -0400
MIME-Version: 1.0
In-Reply-To: <87pphenxex.fsf@tassilo.jf.intel.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
	<1404905415-9046-2-git-send-email-a.ryabinin@samsung.com>
	<87pphenxex.fsf@tassilo.jf.intel.com>
Date: Thu, 10 Jul 2014 00:40:58 +0400
Message-ID: <CAJOtW+5=5EGwLyAA+33y4E9UGuGHuXQkf6rTEsh0e7rqoNBKCg@mail.gmail.com>
Subject: Re: [RFC/PATCH RESEND -next 01/21] Add kernel address sanitizer infrastructure.
From: Yuri Gribov <tetra2005@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 11:29 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Hardcoding --param is not very nice. They can change from compiler
> to compiler version. Need some version checking?

We plan to address this soon. CFLAGS will look more like
-fsanitize=kernel-address but this flag is not yet in gcc.

-Y
