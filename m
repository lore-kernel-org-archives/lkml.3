Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaIAERQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 00:17:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbaIAERP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 00:17:15 -0400
Date: Mon, 1 Sep 2014 00:08:45 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 0/6] hugepage migration fixes (v3)
Message-ID: <20140901040845.GA30158@nhori>
References: <1409276340-7054-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <87tx4sk7bs.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tx4sk7bs.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 08:27:35AM -0700, Andi Kleen wrote:
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
> 
> > This is the ver.3 of hugepage migration fix patchset.
> 
> I wonder how far we are away from support THP migration with the
> standard migrate_pages() syscall?

I don't think that we are very far from this because we can borrow
some code from migrate_misplaced_transhuge_page(), and the experience
in hugetlb migration will be also helpful.
The difficulties are rather in integrating thp support in the existing
migrate code which is already very complicated, so careful code-reading
and testing is necessary.
This topic was in my agenda for long, but no highlight at this point.

Thanks,
Naoya Horiguchi
