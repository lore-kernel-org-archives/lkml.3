Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513Ab3JKQbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:31:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758344Ab3JKQbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:31:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1381428359-14843-16-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-16-git-send-email-kirill.shutemov@linux.intel.com> <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 15/34] frv: handle pgtable_page_ctor() fail
Date: Fri, 11 Oct 2013 17:30:10 +0100
Message-ID: <15762.1381509010@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: David Howells <dhowells@redhat.com>

for the FRV and MN10300 patches.

Can you move pte_alloc_one() to common code, at least for some arches?  I
think that the FRV and MN10300 ones should end up the same after this - and I
wouldn't be surprised if some of the other arches do too.

David
