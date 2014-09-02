Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaIBOQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:16:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaIBOQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:16:18 -0400
Date: Tue, 2 Sep 2014 16:13:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <sbsiddha@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86, fpu: irq_fpu_usable: kill all checks except
	!in_kernel_fpu
Message-ID: <20140902141340.GA23771@redhat.com>
References: <20140827185138.GA12487@redhat.com> <CA+55aFwi-S27_maZXU+baOqPAYfi_NTGcfbnRnk45+B8+i4hVQ@mail.gmail.com> <20140828111628.GB15276@redhat.com> <20140829181533.GA30659@redhat.com> <20140829181729.GE30659@redhat.com> <CALmL7E8mTeALSjSXkgVQs=KW9AX5K4r5k63foiP0Vy5ue8Vfgg@mail.gmail.com> <20140902125810.GB18534@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902125810.GB18534@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for noise, but just in case...

On 09/02, Oleg Nesterov wrote:
>
> Do you think this can work?

Of course, even if this can work, we should do this later. Let's start
with the simple changes, then we will see if we can actually remove all
other checks.

Oleg.

