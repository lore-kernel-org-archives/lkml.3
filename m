Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaJBT0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:26:06 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:35058 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaJBT0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:26:04 -0400
MIME-Version: 1.0
In-Reply-To: <20141002190734.GA15671@node.dhcp.inet.fi>
References: <1412256558-9995-1-git-send-email-mgorman@suse.de>
	<1412256558-9995-5-git-send-email-mgorman@suse.de>
	<CA+55aFzJtoEXEzoyYQ=j+AMxyZNL3Gr3bhXPr3twyuGzvES1PA@mail.gmail.com>
	<542DA038.9000908@oracle.com>
	<CA+55aFwybOYtuOn43idiikVDPfBO7pWb4vLjhcM0dYUxTx7odA@mail.gmail.com>
	<20141002190734.GA15671@node.dhcp.inet.fi>
Date: Thu, 2 Oct 2014 12:26:02 -0700
X-Google-Sender-Auth: evZbGqCodRGcIW5ptms2G5C1iYI
Message-ID: <CA+55aFzNGCiaL5fWpi_-JJXBhCuS+6CgUa0GpmFHRWWTGXp4fQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm: numa: Do not mark PTEs pte_numa when splitting
 huge pages
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Sasha Levin <sasha.levin@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 12:07 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
>
> I believe Sasha uses fakenuma in his KVM for that.

Ok, so the benchmarks won't do anything then.

I mean, I guess they might show some of the migration overhead, but
they won't show the actual end result in any meaningful manner, since
memory isn't actually NUMA.

                Linus
