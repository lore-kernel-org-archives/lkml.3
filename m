Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaBZXYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:24:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaBZXYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:24:37 -0500
Date: Wed, 26 Feb 2014 15:24:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        schwidefsky@de.ibm.com, rientjes@google.com, riel@redhat.com,
        pbonzini@redhat.com, mingo@kernel.org, mgorman@suse.de,
        kirill.shutemov@linux.intel.com, heiko.carstens@de.ibm.com,
        hannes@cmpxchg.org, gerald.schaefer@de.ibm.com, ebiederm@xmission.com,
        aarcange@redhat.com
Subject: Re: + mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
 added to -mm tree
Message-Id: <20140226152434.8faabadc7f4f8d6475d58f88@linux-foundation.org>
In-Reply-To: <20140226193917.GR3041@sgi.com>
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org>
	<530D9F50.1080400@de.ibm.com>
	<20140226145025.GA12571@redhat.com>
	<530E0306.7020601@de.ibm.com>
	<20140226153144.GA15527@redhat.com>
	<20140226165759.GB22802@laptop.programming.kicks-ass.net>
	<20140226172253.GQ3041@sgi.com>
	<20140226180603.GA25644@redhat.com>
	<530E4028.70903@de.ibm.com>
	<20140226193917.GR3041@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 13:39:17 -0600 Alex Thorlton <athorlton@sgi.com> wrote:

> > 
> > 
> > > I'd suggest the patch below on top of your changes, but I won't argue.
> 
> I like this approach, and your updated comment as well.  This should
> probably go in as [PATCH 2/4] in my series.  Do I need to spin a v5
> with this new patch included in the series, or will Andrew pull this in?

Paolo's comments on Oleg's patch remain unaddressed, so please take a
look at that and send out the final version?

An incremental patch would be preferred, please.  I'll later fold that
into mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch to
avoid any bisection holes.
