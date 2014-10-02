Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaJBTcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:32:43 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:61826 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaJBTcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:32:41 -0400
MIME-Version: 1.0
In-Reply-To: <542DA767.3000601@redhat.com>
References: <1412256558-9995-1-git-send-email-mgorman@suse.de>
	<1412256558-9995-5-git-send-email-mgorman@suse.de>
	<CA+55aFzJtoEXEzoyYQ=j+AMxyZNL3Gr3bhXPr3twyuGzvES1PA@mail.gmail.com>
	<542DA038.9000908@oracle.com>
	<CA+55aFwybOYtuOn43idiikVDPfBO7pWb4vLjhcM0dYUxTx7odA@mail.gmail.com>
	<20141002190734.GA15671@node.dhcp.inet.fi>
	<CA+55aFzNGCiaL5fWpi_-JJXBhCuS+6CgUa0GpmFHRWWTGXp4fQ@mail.gmail.com>
	<542DA767.3000601@redhat.com>
Date: Thu, 2 Oct 2014 12:32:40 -0700
X-Google-Sender-Auth: QraZTkaif2vk4aN4XmcZq-Sc8UA
Message-ID: <CA+55aFxhbiMec+bywcvUVO17UU9UC97PLSqqnrv10dtSRzmhAg@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm: numa: Do not mark PTEs pte_numa when splitting
 huge pages
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Sasha Levin <sasha.levin@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 12:28 PM, Rik van Riel <riel@redhat.com> wrote:
>
> They are more useful as sanity tests than anything else.

.. and that's exactly what I'd like to hear about the protnone patch.
Did the patch screw something up so that it doesn't count the faults
properly?

              Linus
