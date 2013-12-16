Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3LPKMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:12:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34213 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3LPKMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:12:43 -0500
Date: Mon, 16 Dec 2013 11:12:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mm: ptl is not bloated if it fits in pointer
Message-ID: <20131216101233.GV21999@twins.programming.kicks-ass.net>
References: <alpine.LNX.2.00.1312160053530.3066@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1312160053530.3066@eggly.anvils>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 01:04:13AM -0800, Hugh Dickins wrote:
> It's silly to force the 64-bit CONFIG_GENERIC_LOCKBREAK architectures

So yes that's unfortunate, but why are people using that
GENERIC_LOCKBREAK stuff to begin with? Its atrocious, a much better path
would be to remove it.
