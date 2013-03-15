Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3CONcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:32:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:33379 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab3CONcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:32:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="307142970"
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
In-Reply-To: <CAJd=RBCU=aaH-Osq-3gXSHZsropU=7yPU-ay7zvWoKsdoBOn6g@mail.gmail.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CAJd=RBCU=aaH-Osq-3gXSHZsropU=7yPU-ay7zvWoKsdoBOn6g@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 00/30] Transparent huge page cache
Content-Transfer-Encoding: 7bit
Message-Id: <20130315133348.8FA3CE0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 15:33:48 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> >
> > Here's the second version of the patchset.
> >
> > The intend of the work is get code ready to enable transparent huge page
> > cache for the most simple fs -- ramfs.
> >
> Where is your git tree including THP cache?

Here: git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git

Tag thp/pagecache/v2 represents the patcheset.
Branch thp/pagecache has fixed according to your feedback.

-- 
 Kirill A. Shutemov
