Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaLCWY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:24:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:52593 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaLCWY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:24:56 -0500
Message-ID: <1417640517.4741.14.camel@kernel.crashing.org>
Subject: Re: [PATCH 03/10] mm: Convert p[te|md]_numa users to
 p[te|md]_protnone_numa
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mel Gorman <mgorman@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 04 Dec 2014 08:01:57 +1100
In-Reply-To: <20141203155242.GE6043@suse.de>
References: <1416578268-19597-1-git-send-email-mgorman@suse.de>
	 <1416578268-19597-4-git-send-email-mgorman@suse.de>
	 <1417473762.7182.8.camel@kernel.crashing.org>
	 <87k32ah5q3.fsf@linux.vnet.ibm.com>
	 <1417551115.27448.7.camel@kernel.crashing.org>
	 <87lhmobvuu.fsf@linux.vnet.ibm.com> <20141203155242.GE6043@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 15:52 +0000, Mel Gorman wrote:
> 
> It's implied but can I assume it passed? If so, Ben and Paul, can I
> consider the series to be acked by you other than the minor comment
> updates?

Yes. Assuming it passed :-)

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.


