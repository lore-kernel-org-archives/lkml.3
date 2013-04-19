Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343Ab3DSVkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 17:40:10 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40276 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933973Ab3DSVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 17:40:05 -0400
Date: Fri, 19 Apr 2013 14:39:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@surriel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        Emmanuel Benisty <benisty.e@gmail.com>
Subject: Re: linux-next: Tree for Apr 18 [ call-trace: drm | x86 | smp | rcu
 related? ]
Message-ID: <20130419213953.GN3479@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAKMK7uFEaiT_1siQBcp_-S0RwLvy3XSjqLn1ksq70VhNTZSfLw@mail.gmail.com>
 <CA+icZUWQEiGecR8jgw4P-2YCKyqSDMMP0Ufwn8aBU_-AOf0a-Q@mail.gmail.com>
 <CA+icZUWcwvFFVesJDoFNT3DbgRMXvDp7QLn+S5Ze_5d8gJRx1g@mail.gmail.com>
 <CA+icZUXjTGSG+tejOAFgXr8EpKd7dL=-W41ha_-0N=roAxN3eg@mail.gmail.com>
 <CA+icZUVE-ikxEp65bUHMp0WEPX_MDbA06ykzeSxygJv=9f45ig@mail.gmail.com>
 <CA+icZUUp84vzF_0n77wsJ6dBOS26vSRCXaFUDbCQi-wG0b-Osg@mail.gmail.com>
 <517198A7.8020904@surriel.com>
 <1366402328.5317.9.camel@buesod1.americas.hpqcorp.net>
 <CA+icZUVjx7pDJWo3tGxX3ANXtiTP0_Q1YyOowANhn1wzcSgWaA@mail.gmail.com>
 <CA+55aFzU5C9UQGNFx+wQ_Rp0gZAAwLj77qO7fH7LEduD7bk1Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzU5C9UQGNFx+wQ_Rp0gZAAwLj77qO7fH7LEduD7bk1Kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041921-5518-0000-0000-00000DBA97FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 02:24:10PM -0700, Linus Torvalds wrote:
> On Fri, Apr 19, 2013 at 2:09 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > I have applied all three patches and see still call-traces.
> > New are apparmor related messages.
> 
> Can you try the crazy rcu double-free debug hack?
> 
> See
> 
>     https://lkml.org/lkml/2013/3/30/113
> 
> and I'm re-attaching the ugly-ass crazy hack patch here too..
> 
>                     Linus

For whatever it is worth, CONFIG_DEBUG_OBJECTS_RCU_HEAD=y is intended to
detect RCU double-freeing.  But if it isn't helping for whatever reason,
please let me know!

							Thanx, Paul

