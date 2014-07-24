Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355AbaGXRMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:12:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57571 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaGXRMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:12:42 -0400
Message-ID: <1406221948.3612.51.camel@fourier>
Subject: Re: [PATCH 3.8 107/116] hugetlb: fix copy_hugetlb_page_range() to
 handle migration/hwpoisoned entry
From: Kamal Mostafa <kamal@canonical.com>
To: Hugh Dickins <hughd@google.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Jul 2014 10:12:28 -0700
In-Reply-To: <alpine.LSU.2.11.1407231659330.2093@eggly.anvils>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
	 <1406067727-19683-108-git-send-email-kamal@canonical.com>
	 <alpine.LSU.2.11.1407221608040.3128@eggly.anvils>
	 <1406149325.3612.33.camel@fourier>
	 <alpine.LSU.2.11.1407231659330.2093@eggly.anvils>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 17:07 -0700, Hugh Dickins wrote:
> 
> commit 0253d634e0803a8376a0d88efee0bf523d8673f9
> Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date:   Wed Jul 23 14:00:19 2014 -0700
> mm: hugetlb: fix copy_hugetlb_page_range()
> 
> is now in Linus's tree: so the original patch is good to go into
> your -stables, so long as you add 0253d634e080 on top.
> 
> Hugh

OK, I have queued both for the imminent 3.8-stable release:
        
        4a705fe hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned entry
        0253d63 mm: hugetlb: fix copy_hugetlb_page_range()

The first patch was already released in the previous 3.13-stable cycle;
I've now queued up the second for the next 3.13 cycle.

Thanks again, Hugh and Naoya-san!

 -Kamal


