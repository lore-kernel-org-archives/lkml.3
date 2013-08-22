Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3HVNM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:12:26 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:63274 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3HVNMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:12:24 -0400
Date: Thu, 22 Aug 2013 17:12:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
Message-ID: <20130822131221.GM18673@moon>
References: <5214C524.1050900@citrix.com>
 <dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com>
 <20130821141926.GT18673@moon>
 <CA+55aFyk6s1t92HJ5rxKZQk6dTfszmhdXz+S=MqUmM-CbMo+DQ@mail.gmail.com>
 <20130821230557.GD18673@moon>
 <87wqnehapu.fsf@tassilo.jf.intel.com>
 <20130822054919.GF18673@moon>
 <20130822063733.GG4665@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822063733.GG4665@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 03:37:33PM +0900, Minchan Kim wrote:
> > 
> > Look, good thing is that 7th bit also available on the 4level pages
> > (ie x86-64) without additional code modification, that's why I picked
> > it in first place. I prepared the patch locally which doesn't use
> > pse bit for tracking but it only makes code more complex.
> 
> I'm not sure you read this thread.
> http://comments.gmane.org/gmane.linux.kernel.mm/101756
> In summary, I'd like to use it to track sub-ranges of some processes.
> 
> I already had a time to investigate and it enhanced our workload x2 on ARM
> so I'd like to expand the concept for more general purpose.
> 
> For it, arch-specific stuff would be hurdle for port.
> So, I support your non-arch-specific solutions.
> Just FYI. Such future plan shouldn't force you.

Hi Minchan, thanks for info, I'll read the thread (sorry for delay,
managed to miss your email).
