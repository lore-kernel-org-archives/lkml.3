Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaETCfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:35:47 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60505 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaETCfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:35:44 -0400
Date: Mon, 19 May 2014 19:34:27 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        riel@redhat.com, mgorman@suse.de, ak@linux.intel.com,
        peterz@infradead.org, mingo@kernel.org, dave.hansen@intel.com
Subject: Re: [PATCH V4 0/2] mm: FAULT_AROUND_ORDER patchset performance data
 for powerpc
In-Reply-To: <87d2f9jlpd.fsf@rustcorp.com.au>
Message-ID: <alpine.LSU.2.11.1405191930130.3574@eggly.anvils>
References: <1399541296-18810-1-git-send-email-maddy@linux.vnet.ibm.com> <537479E7.90806@linux.vnet.ibm.com> <alpine.LSU.2.11.1405151026540.4664@eggly.anvils> <87wqdik4n5.fsf@rustcorp.com.au> <53797511.1050409@linux.vnet.ibm.com> <alpine.LSU.2.11.1405191531150.1317@eggly.anvils>
 <87d2f9jlpd.fsf@rustcorp.com.au>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Rusty Russell wrote:
> Hugh Dickins <hughd@google.com> writes:
> >> On Monday 19 May 2014 05:42 AM, Rusty Russell wrote:
> >> > 
> >> > Perhaps we try to generalize from two data points (a slight improvement
> >> > over doing it from 1!), eg:
> >> > 
> >> > /* 4 seems good for 4k-page x86, 0 seems good for 64k page ppc64, so: */
> >> > unsigned int fault_around_order __read_mostly =
> >> >         (16 - PAGE_SHIFT < 0 ? 0 : 16 - PAGE_SHIFT);
> >
> > Rusty's bimodal answer doesn't seem the right starting point to me.
> 
> ?  It's not bimodal, it's graded.  I think you misread?

Yikes, worse than misread, more like I was too rude even to read: sorry!

Hugh
