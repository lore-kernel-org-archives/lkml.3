Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaJBTEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:04:00 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:45398 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaJBTD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <542DA038.9000908@oracle.com>
References: <1412256558-9995-1-git-send-email-mgorman@suse.de>
	<1412256558-9995-5-git-send-email-mgorman@suse.de>
	<CA+55aFzJtoEXEzoyYQ=j+AMxyZNL3Gr3bhXPr3twyuGzvES1PA@mail.gmail.com>
	<542DA038.9000908@oracle.com>
Date: Thu, 2 Oct 2014 12:03:58 -0700
X-Google-Sender-Auth: btPjCEVa7dLr3JBoxQYFMAlWR2Q
Message-ID: <CA+55aFwybOYtuOn43idiikVDPfBO7pWb4vLjhcM0dYUxTx7odA@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm: numa: Do not mark PTEs pte_numa when splitting
 huge pages
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 11:58 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> You've also mentioned that while I can tell you if nothing dies, I can't
> really tell you if everything is working well. Is there a reasonable way
> to easily say if NUMA is working properly? Even something that would just
> tell me "your NUMA balancing seems to be sane" would be good.

So not having a NUMA machine (and not really wanting one), I can't
really test things like the migration even *working*.

But the easy/obvious test would be to run the autonuma benchmarks, and
verify that the performance is where it's expected to be and that the
migration actually works.

I think the "main" source site is

  https://gitorious.org/autonuma-benchmark

but haven't verified.

             Linus
