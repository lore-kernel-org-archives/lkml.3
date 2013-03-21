Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab3CURRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:17:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:29025 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab3CURRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:17:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,887,1355126400"; 
   d="scan'208";a="274197684"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <514B1D32.5030400@sr71.net>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-2-git-send-email-kirill.shutemov@linux.intel.com>
 <514B1D32.5030400@sr71.net>
Subject: Re: [PATCHv2, RFC 01/30] block: implement add_bdi_stat()
Content-Transfer-Encoding: 7bit
Message-Id: <20130321171923.80B4DE0085@blue.fi.intel.com>
Date: Thu, 21 Mar 2013 19:19:23 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > 
> > It's required for batched stats update.
> 
> The description here is a little terse.  Could you at least also
> describe how and where it's going to get used in later patches?  Just a
> sentence or two more would be really helpful.
> 
> You might also mention that it's essentially a clone of dec_bdi_stat().

Okay. Will update the description. Thanks.

-- 
 Kirill A. Shutemov
