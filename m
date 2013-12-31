Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3LaQ0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:26:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48764 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3LaQ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:26:45 -0500
Date: Tue, 31 Dec 2013 17:26:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, akpm@linux-foundation.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 1/2] mm: additional page lock debugging
Message-ID: <20131231162636.GD16438@laptop.programming.kicks-ass.net>
References: <1388281504-11453-1-git-send-email-sasha.levin@oracle.com>
 <20131230114317.GA8117@node.dhcp.inet.fi>
 <52C1A06B.4070605@oracle.com>
 <20131230224808.GA11674@node.dhcp.inet.fi>
 <52C2385A.8020608@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C2385A.8020608@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 10:22:02PM -0500, Sasha Levin wrote:

> I really want to use lockdep here, but I'm not really sure how to handle locks which live
> for a rather long while instead of being locked and unlocked in the same function like
> most of the rest of the kernel. (Cc Ingo, PeterZ).

Uh what? Lockdep doesn't care about which function locks and unlocks a
particular lock. Nor does it care how long its held for.
