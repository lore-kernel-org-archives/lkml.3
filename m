Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbaITGXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 02:23:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbaITGXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 02:23:54 -0400
Date: Fri, 19 Sep 2014 23:23:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v2 4/6] mm: introduce common page state for ballooned
 memory
Message-Id: <20140919232348.1a2856c1.akpm@linux-foundation.org>
In-Reply-To: <CALYGNiOwrM+LiadZGh+jeFgXCuCA0z_1Vd_kdMxLjqnP9Fnmhw@mail.gmail.com>
References: <20140830163834.29066.98205.stgit@zurg>
	<20140830164120.29066.8857.stgit@zurg>
	<20140912165143.86d5f83dcde4a9fd78069f79@linux-foundation.org>
	<CALYGNiM0Uh1KG8Z6pFEAn=uxZBRPfHDffXjKkKJoG-K0hCaqaA@mail.gmail.com>
	<20140912224221.9ee5888a.akpm@linux-foundation.org>
	<CALYGNiNg5yLbAvqwG3nPqWZHkqXc1-3p4yqdP2Eo2rNJbRo0rg@mail.gmail.com>
	<20140919143520.94f4a17f752398a6c7c927d8@linux-foundation.org>
	<CALYGNiOwrM+LiadZGh+jeFgXCuCA0z_1Vd_kdMxLjqnP9Fnmhw@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2014 09:25:01 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:

> >
> > So I'm going to send "fix for
> > mm-balloon_compaction-use-common-page-ballooning-v2" to Linus
> > separately, but it has no changelog at all.
> 
> Probably it would be better if you drop everything except actually
> fixes and stresstest. This is gone too far, now balloon won't compile
> in the middle of patchset. Just tell me and I'll redo the rest.

I think it's best if I drop everything:

mm-balloon_compaction-ignore-anonymous-pages.patch
mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch
mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch
selftests-vm-transhuge-stress-stress-test-for-memory-compaction.patch
mm-introduce-common-page-state-for-ballooned-memory.patch
mm-balloon_compaction-use-common-page-ballooning.patch
mm-balloon_compaction-general-cleanup.patch
mm-balloon_compaction-use-common-page-ballooning-v2-fix-1.patch

Please go through it and send out a new version?


