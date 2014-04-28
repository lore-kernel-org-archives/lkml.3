Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbaD1P4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:56:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:53331 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbaD1Pzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:55:46 -0400
Date: Mon, 28 Apr 2014 17:55:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        kirill.shutemov@linux.intel.com, Rik van Riel <riel@redhat.com>,
        Jiang Liu <liuj97@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        sasha.levin@oracle.com, liwanp@linux.vnet.ibm.com,
        khalid.aziz@oracle.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] mm: introdule compound_head_by_tail()
Message-ID: <20140428155540.GJ27561@twins.programming.kicks-ass.net>
References: <c232030f96bdc60aef967b0d350208e74dc7f57d.1398605516.git.nasa4836@gmail.com>
 <2c87e00d633153ba7b710bab12710cc3a58704dd.1398605516.git.nasa4836@gmail.com>
 <20140428145440.GB7839@dhcp22.suse.cz>
 <CAHz2CGUueeXR2UdLXBRihVN3R8qEUR8wWhpxYjA6pu3ONO0cJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHz2CGUueeXR2UdLXBRihVN3R8qEUR8wWhpxYjA6pu3ONO0cJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 11:53:28PM +0800, Jianyu Zhan wrote:
> Actually, I checked the assembled code, the compiler is _not_
> so smart to recognize this case. It just does optimization as
> the hint unlikely() told it.

What version, and why didn't your changelog include this useful
information?
