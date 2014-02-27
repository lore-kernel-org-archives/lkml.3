Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaB0ARZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:17:25 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:38321 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbaB0ARV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:17:21 -0500
MIME-Version: 1.0
In-Reply-To: <1393459641.25123.21.camel@buesod1.americas.hpqcorp.net>
References: <1393459641.25123.21.camel@buesod1.americas.hpqcorp.net>
Date: Wed, 26 Feb 2014 16:17:17 -0800
X-Google-Sender-Auth: GQ-Kvi_MwxY2eGlyPII-qbiE1F8
Message-ID: <CA+55aFyG=UroQxhpfiU-fah7m_O3TFxdbo-S-eUGApddP-zsgA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: per-thread vma caching
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I think this is in a mergable form.

I wonder what the heck that insane tlb flush is in
kgdb_flush_swbreak_addr(), but it predates this, and while it makes no
sense to me, the patch makes it no worse. And I can't find it in
myself to care.

Does anybody see anything odd? If not, add an acked-by from me and put
it in -mm, or what?

                Linus
