Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935357AbaICXqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:46:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:20948 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406AbaICXqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:46:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,461,1406617200"; 
   d="scan'208";a="597593740"
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: Tainting the kernel on raw I/O access
References: <5407863B.9030608@intel.com>
Date: Wed, 03 Sep 2014 16:46:18 -0700
In-Reply-To: <5407863B.9030608@intel.com> (H. Peter Anvin's message of "Wed,
	03 Sep 2014 14:20:59 -0700")
Message-ID: <87tx4op8s5.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <h.peter.anvin@intel.com> writes:

> In a meeting earlier today, we discussed MSR access and that it could be
> used to do bad things.  The same applies to other forms of raw I/O
> (/dev/mem, /dev/port, ioperm, iopl, etc.)

I don't think it makes sense to use the taint flags as a security
mechanism. They would be a very poor (and likely by itself insecure) one.

As for the original purpose of taints, I'm not aware of any
problems with MSR access or port IO causing excessive 
kernel oops reports. Are you?

If there are none I don't think it makes sense.

At least personally I use MSR accesses quite frequently
for benign purposes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
