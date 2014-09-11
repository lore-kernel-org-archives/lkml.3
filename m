Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaIKWjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:39:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49149 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbaIKWjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:39:20 -0400
Message-ID: <5412246E.109@oracle.com>
Date: Thu, 11 Sep 2014 18:38:38 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
References: <54082B25.9090600@oracle.com> <20140908171853.GN17501@suse.de> <540DEDE7.4020300@oracle.com> <20140909213309.GQ17501@suse.de> <540F7D42.1020402@oracle.com> <alpine.LSU.2.11.1409091903390.10989@eggly.anvils> <20140910124732.GT17501@suse.de> <alpine.LSU.2.11.1409101210520.1744@eggly.anvils> <54110C62.4030702@oracle.com> <alpine.LSU.2.11.1409110356280.2116@eggly.anvils> <20140911162827.GZ17501@suse.de>
In-Reply-To: <20140911162827.GZ17501@suse.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 12:28 PM, Mel Gorman wrote:
> Agreed. If 3.17-rc4 looks stable with the VM_BUG_ON then it would be
> really nice if you could bisect 3.17-rc4 to linux-next carrying the
> VM_BUG_ON(!(val & _PAGE_PRESENT)) check at each bisection point. I'm not
> 100% sure if I'm seeing the same corruption as you or some other issue and
> do not want to conflate numerous different problems into one. I know this
> is a pain in the ass but if 3.17-rc4 looks stable then a bisection might
> be faster overall than my constant head scratching :(

The good news are that 3.17-rc4 seems to be stable. I'll start the bisection,
which I suspect would take several days. I'll update when I run into something.


Thanks,
Sasha
