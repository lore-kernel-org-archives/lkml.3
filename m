Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaEIOGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:06:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:23355 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaEIOGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1018,1389772800"; 
   d="scan'208";a="529151129"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Armin Rigo <arigo@tunes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
In-Reply-To: <CA+55aFw9eiaFtr+c4gcGSWG=pPeqDnX5aPQMVMqX1XkPF30ahg@mail.gmail.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com>
 <20140508160205.A0EC7E009B@blue.fi.intel.com>
 <CA+55aFw9eiaFtr+c4gcGSWG=pPeqDnX5aPQMVMqX1XkPF30ahg@mail.gmail.com>
Subject: Re: [PATCHv2 0/2] remap_file_pages() decommission
Content-Transfer-Encoding: 7bit
Message-Id: <20140509140536.F06BFE009B@blue.fi.intel.com>
Date: Fri,  9 May 2014 17:05:36 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, May 8, 2014 at 9:02 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> >
> >> i.e. if you remove or
> >> emulate remap_file_pages(), please increase the default limit as well.
> >
> > It's fine to me. Andrew?
> 
> Not Andrew, but one thing we might look at is to make the limit
> per-user rather than per-vm.

Hm. I'm confused here. Do we have any limit forced per-user?
I only see things like rlimits which are copied from parrent.
Is it what you want?

-- 
 Kirill A. Shutemov
