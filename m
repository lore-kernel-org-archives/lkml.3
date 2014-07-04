Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbaGDBnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:43:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbaGDBnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:43:11 -0400
Date: Thu, 3 Jul 2014 21:41:51 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v2 1/4] define PAGECACHE_TAG_* as enumeration under
 include/uapi
Message-ID: <20140704014151.GA9869@nhori>
References: <1404424335-30128-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1404424335-30128-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140704011639.GG9508@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704011639.GG9508@dastard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 11:16:39AM +1000, Dave Chinner wrote:
> On Thu, Jul 03, 2014 at 05:52:12PM -0400, Naoya Horiguchi wrote:
> > We need the pagecache tags to be exported to userspace later in this
> > series for fincore(2), so this patch moves the definition to the new
> > include file for preparation. We also use the number of pagecache tags,
> > so this patch also adds it.
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 
> NACK.
> 
> The radix tree tags are deeply internal implementation details.
> They are an artifact of the current mark-and-sweep writeback
> algorithm, and as such should never, ever be exposed to userspace,
> let alone fixed in an ABI we need to support forever more.

Hm, OK, so I'll do whole this series without pagecache tag things.

Thanks,
Naoya Horiguchi
