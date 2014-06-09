Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaFINfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:35:40 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:34333 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbaFINfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:35:37 -0400
Date: Mon, 9 Jun 2014 09:35:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.12 068/146] revert "mm: vmscan: do not swap anon pages
 just because free+file is low"
Message-ID: <20140609133531.GD2878@cmpxchg.org>
References: <cover.1402303820.git.jslaby@suse.cz>
 <245fd39e32a9e849fab4120e09950bb073b8982e.1402303821.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <245fd39e32a9e849fab4120e09950bb073b8982e.1402303821.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 10:50:03AM +0200, Jiri Slaby wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ===============
> 
> commit 623762517e2370be3b3f95f4fe08d6c063a49b06 upstream.
> 
> This reverts commit 0bf1457f0cfc ("mm: vmscan: do not swap anon pages
> just because free+file is low") because it introduced a regression in

That commit never made it into 3.12, please don't merge the revert as
it would introduce duplicate code.

Thanks!
