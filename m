Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab3CKHuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:50:24 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:50754 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3CKHuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:50:22 -0400
Date: Mon, 11 Mar 2013 08:50:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Michel Lespinasse <walken@google.com>, Alex Shi <alex.shi@intel.com>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] rwsem: wake all readers when first waiter is a
 reader
Message-ID: <20130311075018.GA10514@gmail.com>
References: <1362612111-28673-1-git-send-email-walken@google.com>
 <1362612111-28673-12-git-send-email-walken@google.com>
 <20130309003221.GE23616@dastard>
 <CANN689F9Zy=cTdi3D4d4iw66eeGLTtpudmAJgxYHGgDUsNU2Mg@mail.gmail.com>
 <20130311001650.GB20565@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311001650.GB20565@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Chinner <david@fromorbit.com> wrote:

> So, that's my concern - we've got 20 years of algorithms in XFS designed 
> around rwsem write locks providing read-side barriers, and it's been 
> down this road once before (over 15 years ago). [...]

We are certainly not going to break reader/writer fairness - that's a must 
for any generic, long-held reader-writer locking mechanism.

Thanks,

	Ingo
