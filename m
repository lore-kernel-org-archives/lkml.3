Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3DKFbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 01:31:46 -0400
Received: from ozlabs.org ([203.10.76.45]:39364 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3DKFbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 01:31:45 -0400
Date: Thu, 11 Apr 2013 15:31:06 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Robin Holt <holt@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130411053106.GA9042@drongo>
References: <20130403193743.GB29151@sgi.com>
 <20130408155701.GB19974@gmail.com>
 <5162EC1A.4050204@zytor.com>
 <20130408165916.GA3672@sgi.com>
 <20130410111620.GB29752@gmail.com>
 <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 08:10:05AM -0700, Linus Torvalds wrote:
> The optimal solution would be to just speed up the
> disable_nonboot_cpus() code so much that it isn't an issue. That would
> be good for suspending too, although I guess suspend isn't a big issue
> if you have a thousand CPU's.
> 
> Has anybody checked whether we could do the cpu_down() on non-boot
> CPU's in parallel? Right now we serialize the thing completely, with

I thought Srivatsa S. Bhat had a patchset that did exactly that.
Srivatsa?

Paul.
