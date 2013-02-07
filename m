Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3BGBKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:10:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3BGBKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:10:49 -0500
Date: Wed, 6 Feb 2013 17:10:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: use long type for page counts in mm_populate()
 and get_user_pages()
Message-Id: <20130206171047.d27b5772.akpm@linux-foundation.org>
In-Reply-To: <5112F7AF.6010307@oracle.com>
References: <1359591980-29542-1-git-send-email-walken@google.com>
	<1359591980-29542-2-git-send-email-walken@google.com>
	<5112F7AF.6010307@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2013 19:39:11 -0500
Sasha Levin <sasha.levin@oracle.com> wrote:

> We're now hitting the VM_BUG_ON() which was added in the last hunk of the
> patch:

hm, why was that added.

Michel, I seem to have confused myself over this series.  I saw a
report this morning which led me to drop
mm-accelerate-munlock-treatment-of-thp-pages.patch but now I can't find
that report and I'm wondering if I should have dropped
mm-accelerate-mm_populate-treatment-of-thp-pages.patch instead.

Given that and Sasha's new report I think I'll drop

mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix-fix.patch
mm-accelerate-mm_populate-treatment-of-thp-pages.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

and let's start again?
