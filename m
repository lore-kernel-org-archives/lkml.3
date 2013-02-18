Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab3BRGOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:14:55 -0500
Received: from ozlabs.org ([203.10.76.45]:35895 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab3BRGOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:14:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
        Stewart Smith <stewart@flamingspork.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [patch 1/2] mm: fincore()
In-Reply-To: <20130215154235.0fb36f53.akpm@linux-foundation.org>
References: <87a9rbh7b4.fsf@rustcorp.com.au> <20130211162701.GB13218@cmpxchg.org> <20130211141239.f4decf03.akpm@linux-foundation.org> <20130215063450.GA24047@cmpxchg.org> <20130215132738.c85c9eda.akpm@linux-foundation.org> <20130215231304.GB23930@cmpxchg.org> <20130215154235.0fb36f53.akpm@linux-foundation.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 18 Feb 2013 16:11:08 +1030
Message-ID: <87zjz2i3gr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> The syscall should handle the common usages very well.  But it
> shouldn't handle uncommon usages very badly!

If the user is actually dealing with the contents of the file, following
the established mincore is preferred, since it's in the noise anyway.

Which comes back to needing a user; I'll see what I can come up with.

Cheers,
Rusty.


