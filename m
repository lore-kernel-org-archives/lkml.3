Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3CON1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:27:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:31441 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab3CON1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:27:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="302738958"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAJd=RBD2jWsMOjwXenbHu_Y3-jRm+=XR+h44Tw4KRKEb79ptqg@mail.gmail.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-20-git-send-email-kirill.shutemov@linux.intel.com>
 <CAJd=RBD2jWsMOjwXenbHu_Y3-jRm+=XR+h44Tw4KRKEb79ptqg@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 19/30] thp, mm: split huge page on mmap file page
Content-Transfer-Encoding: 7bit
Message-Id: <20130315132911.63716E0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 15:29:11 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> >
> > We are not ready to mmap file-backed tranparent huge pages.
> >
> It is not on todo list either.

Actually, following patches implement mmap for file-backed thp and this
split_huge_page() will catch only fallback cases.

-- 
 Kirill A. Shutemov
