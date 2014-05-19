Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaESXnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:43:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaESXnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:43:03 -0400
Date: Mon, 19 May 2014 16:43:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org, riel@redhat.com,
        mgorman@suse.de, ak@linux.intel.com, peterz@infradead.org,
        mingo@kernel.org, dave.hansen@intel.com
Subject: Re: [PATCH V4 0/2] mm: FAULT_AROUND_ORDER patchset performance data
 for powerpc
Message-Id: <20140519164301.eafd3dd288ccb88361ddcfc7@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.11.1405191531150.1317@eggly.anvils>
References: <1399541296-18810-1-git-send-email-maddy@linux.vnet.ibm.com>
	<537479E7.90806@linux.vnet.ibm.com>
	<alpine.LSU.2.11.1405151026540.4664@eggly.anvils>
	<87wqdik4n5.fsf@rustcorp.com.au>
	<53797511.1050409@linux.vnet.ibm.com>
	<alpine.LSU.2.11.1405191531150.1317@eggly.anvils>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 16:23:07 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> Shouldn't FAULT_AROUND_ORDER and fault_around_order be changed to be
> the order of the fault-around size in bytes, and fault_around_pages()
> use 1UL << (fault_around_order - PAGE_SHIFT)

Yes.  And shame on me for missing it (this time!) at review.

There's still time to fix this.  Patches, please.
