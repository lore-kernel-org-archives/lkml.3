Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3CONVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:21:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:54849 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab3CONVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:21:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="303415813"
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
In-Reply-To: <CAJd=RBAKGiCb_+yoFog6xao5bF8vqFwE9MGZ9EVbf1fe-dXnDQ@mail.gmail.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-4-git-send-email-kirill.shutemov@linux.intel.com>
 <CAJd=RBAKGiCb_+yoFog6xao5bF8vqFwE9MGZ9EVbf1fe-dXnDQ@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 03/30] mm: drop actor argument of
 do_generic_file_read()
Content-Transfer-Encoding: 7bit
Message-Id: <20130315132246.F0542E0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 15:22:46 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> >
> > There's only one caller of do_generic_file_read() and the only actor is
> > file_read_actor(). No reason to have a callback parameter.
> >
> This cleanup is not urgent if it nukes no barrier for THP cache.

Yes, it's not urgent. On other hand it can be applied upstream right now ;)

-- 
 Kirill A. Shutemov
