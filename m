Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaDQXBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:01:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaDQXBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:01:12 -0400
Date: Thu, 17 Apr 2014 16:01:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        aarcange@redhat.com, mgorman@suse.de, andi@firstfloor.org,
        davidlohr@hp.com, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com,
        kirill@shutemov.name
Subject: Re: [PATCH v3 0/5] hugetlb: add support gigantic page allocation at
 runtime
Message-Id: <20140417160110.3f36b972b25525fbbe23681b@linux-foundation.org>
In-Reply-To: <1397152725-20990-1-git-send-email-lcapitulino@redhat.com>
References: <1397152725-20990-1-git-send-email-lcapitulino@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 13:58:40 -0400 Luiz Capitulino <lcapitulino@redhat.com> wrote:

> The HugeTLB subsystem uses the buddy allocator to allocate hugepages during
> runtime. This means that hugepages allocation during runtime is limited to
> MAX_ORDER order. For archs supporting gigantic pages (that is, page sizes
> greater than MAX_ORDER), this in turn means that those pages can't be
> allocated at runtime.

Dumb question: what's wrong with just increasing MAX_ORDER?
