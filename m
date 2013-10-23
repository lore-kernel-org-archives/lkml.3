Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3JWJaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:30:52 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:52674 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3JWJav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:30:51 -0400
Date: Wed, 23 Oct 2013 02:30:45 -0700
From: walken@google.com
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        aswin@hp.com, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: add mlock_future_check helper
Message-ID: <20131023093045.GA2862@localhost>
References: <1382057438-3306-1-git-send-email-davidlohr@hp.com>
 <1382057438-3306-2-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382057438-3306-2-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 05:50:36PM -0700, Davidlohr Bueso wrote:
> Both do_brk and do_mmap_pgoff verify that we actually
> capable of locking future pages if the corresponding
> VM_LOCKED flags are used. Encapsulate this logic into
> a single mlock_future_check() helper function.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Michel Lespinasse <walken@google.com>

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
