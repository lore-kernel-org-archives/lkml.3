Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3LLXr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:47:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:44710 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab3LLXrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:47:53 -0500
Message-ID: <1386892059.15730.58.camel@pasglop>
Subject: Re: [PATCH v2 1/2] dcache: allow word-at-a-time name hashing with
 big-endian CPUs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Fri, 13 Dec 2013 10:47:39 +1100
In-Reply-To: <CA+55aFz1RwjjbdauN+Y3hbk079KTbeoXb__BHAbO+vOOb5qD6w@mail.gmail.com>
References: <1386870022-31525-1-git-send-email-will.deacon@arm.com>
	 <CA+55aFz1RwjjbdauN+Y3hbk079KTbeoXb__BHAbO+vOOb5qD6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 10:38 -0800, Linus Torvalds wrote:
> Ok, looks good. So I'm taking these even though it's outside the merge
> window - they're small, and until you enable DCACHE_WORD_ACCESS on
> big-endian they don't actually do anything.
> 
> Ben - you might want to check if this makes DCACHE_WORD_ACCESS useful
> on PowerPC too. Right now that requires an efficient fls()
> implementation, but I think you have "cntlz" like ARM does.

Thanks. I'll see if I can get somebody to measure it. It should be good
though.

Cheers,
Ben.


