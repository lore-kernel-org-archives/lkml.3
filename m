Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaH1M1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 08:27:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaH1M1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:27:43 -0400
Date: Thu, 28 Aug 2014 14:25:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86, fpu: copy_process's FPU paths cleanups
Message-ID: <20140828122513.GA19913@redhat.com>
References: <20140827185138.GA12487@redhat.com> <acea7803-1ed3-437e-9f4c-df8dd56feef8@email.android.com> <20140828065057.GB6059@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828065057.GB6059@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28, Ingo Molnar wrote:
>
> * H. Peter Anvin <hpa@zytor.com> wrote:
>
> > Oleg, this is unacceptable.
> >
> > Last week was Kernel Summit and that was right on the heels of
> > a merge window.  We are backlogged like crazy and being rude
> > doesn't help one iota.
>
> Also, the previous set of patches was under active review by
> Linus with objections, we very much wanted to wait for all that
> to conclude one way or another.

Sorry for confusion. But this series and the previous fixes do not
depend on that set of patches.

Oleg.

