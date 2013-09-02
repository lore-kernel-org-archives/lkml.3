Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab3IBLg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:36:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:19469 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab3IBLgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:36:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="scan'208";a="289820565"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Ning Qu <quning@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CACz4_2eY3cniz6mV-Nwi6jBEEOfETJs1GXrjHBppr=Grjnwiqw@mail.gmail.com>
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1375582645-29274-6-git-send-email-kirill.shutemov@linux.intel.com>
 <CACz4_2eY3cniz6mV-Nwi6jBEEOfETJs1GXrjHBppr=Grjnwiqw@mail.gmail.com>
Subject: Re: [PATCH 05/23] thp: represent file thp pages in meminfo and
 friends
Content-Transfer-Encoding: 7bit
Message-Id: <20130902113616.6C750E0090@blue.fi.intel.com>
Date: Mon,  2 Sep 2013 14:36:16 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ning Qu wrote:
> Hi, Kirill
> 
> I believe there is a typo in your previous commit, but you didn't include
> it in this series of patch set. Below is the link for the commit. I think
> you are trying to decrease the value NR_ANON_PAGES in page_remove_rmap, but
> it is currently adding the value instead when using __mod_zone_page_state.Let
> me know if you would like to fix it in your commit or you want another
> patch from me. Thanks!

The patch is already in Andrew's tree. I'll send a fix for that. Thanks.

-- 
 Kirill A. Shutemov
