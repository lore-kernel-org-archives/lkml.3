Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaIEU6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:58:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:34448 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaIEU6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:58:51 -0400
Date: Fri, 5 Sep 2014 22:58:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM changes for 3.17-rc4
In-Reply-To: <CA+55aFxum+O9j4ohV=BwJR_+q+hMAZ2QLp0SpgZzYFWs9F=EUg@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1409052254450.5472@nanos>
References: <1409912186-22968-1-git-send-email-pbonzini@redhat.com> <CA+55aFxum+O9j4ohV=BwJR_+q+hMAZ2QLp0SpgZzYFWs9F=EUg@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Linus Torvalds wrote:

> On Fri, Sep 5, 2014 at 3:16 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
> 
> Nothing new there. Forgot to push out, or perhaps to use "-f" to
> overwrite the previous tag of the same name?

And even if there would be something, please do not pull the top most
commit b11ba8c62be3eb (KVM: x86: fix kvmclock breakage from timers
branch merge).

That one is blantanly wrong and just hacks badly around a brown
paperbag bug in the core timekeeping code, which I introduced in the
last overhaul.

It's debugged and understood. Fix is posted and if confirmed by the
KVM folks it will go to you before rc4.

Thanks,

	tglx


