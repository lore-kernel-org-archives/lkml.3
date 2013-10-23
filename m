Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab3JWJeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:34:00 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:36726 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3JWJd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:33:57 -0400
Date: Wed, 23 Oct 2013 02:33:52 -0700
From: walken@google.com
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        aswin@hp.com, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 2/3] mm/mlock: prepare params outside critical region
Message-ID: <20131023093352.GB2862@localhost>
References: <1382057438-3306-1-git-send-email-davidlohr@hp.com>
 <1382057438-3306-3-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382057438-3306-3-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 05:50:37PM -0700, Davidlohr Bueso wrote:
> All mlock related syscalls prepare lock limits, lengths and
> start parameters with the mmap_sem held. Move this logic
> outside of the critical region. For the case of mlock, continue
> incrementing the amount already locked by mm->locked_vm with
> the rwsem taken.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
