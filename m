Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab3FYNzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:55:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:63900 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab3FYNy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:54:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,937,1363158000"; 
   d="scan'208";a="335247866"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
In-Reply-To: <20130617153120.6EADFE0090@blue.fi.intel.com>
References: <1370964919-16187-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130617153120.6EADFE0090@blue.fi.intel.com>
Subject: [PING] Transparent huge page cache: phase 0, prep work
Content-Transfer-Encoding: 7bit
Message-Id: <20130625135746.E6506E0090@blue.fi.intel.com>
Date: Tue, 25 Jun 2013 16:57:46 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > 
> > My patchset which introduces transparent huge page cache is pretty big and
> > hardly reviewable. Dave Hansen suggested to split it in few parts.
> > 
> > This is the first part: preparation work. I think it's useful without rest
> > patches.
> > 
> > There's one fix for bug in lru_add_page_tail(). I doubt it's possible to
> > trigger it on current code, but nice to have it upstream anyway.
> > Rest is cleanups.
> > 
> > Patch 8 depends on patch 7. Other patches are independent and can be
> > applied separately.
> > 
> > Please, consider applying.
> 
> Andrew, Andrea, any feedback?

Ping?

-- 
 Kirill A. Shutemov
