Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaJESvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 14:51:16 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:36037 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaJESvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 14:51:14 -0400
MIME-Version: 1.0
In-Reply-To: <20141005184115.GA21713@node.dhcp.inet.fi>
References: <alpine.DEB.2.02.1410041947080.7055@chino.kir.corp.google.com>
	<20141005184115.GA21713@node.dhcp.inet.fi>
Date: Sun, 5 Oct 2014 11:51:13 -0700
X-Google-Sender-Auth: ZvFBnypY5oBjy6l-1dpLws49HHw
Message-ID: <CA+55aFzZMuup+00b7yLy=oLbzErEuUXxuBuwGcDCbjM5PbYKaQ@mail.gmail.com>
Subject: Re: [patch for-3.17] mm, thp: fix collapsing of hugepages on madvise
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suleiman Souhlal <suleiman@google.com>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 5, 2014 at 11:41 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
>
> Look like rather complex fix for a not that complex bug.
> What about untested patch below?

Much nicer. This will miss 3.17 because I'm cutting it today and it's
too late to have this discussion for that, but I think I'd prefer to
merge this instead later..

              Linus
