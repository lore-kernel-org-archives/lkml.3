Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab3JIBSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:18:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab3JIBSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:18:53 -0400
Date: Tue, 8 Oct 2013 21:18:33 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fengguang Wu <fengguang.wu@intel.com>, xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131009011833.GA14579@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Fengguang Wu <fengguang.wu@intel.com>,
	xen-devel@lists.xenproject.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
 <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
 <20131008020918.GA1220@localhost>
 <20131008021452.GA6456@localhost>
 <CA+55aFwrovZf-LYa=_SyMNvqQkTfxREm0YuzDk8wJy+Krs0xzw@mail.gmail.com>
 <20131008031152.GA8218@localhost>
 <20131008121742.GA29280@localhost>
 <20131008221417.GF25034@n2100.arm.linux.org.uk>
 <20131008224840.GA15303@kroah.com>
 <CA+55aFzdABn=TiBbM0fdok1xO3UY7hUjXA8q7rUrg2dHCsN=Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzdABn=TiBbM0fdok1xO3UY7hUjXA8q7rUrg2dHCsN=Ng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 05:45:37PM -0700, Linus Torvalds wrote:

 > normally that whole DEBUG_KOBJECT_RELEASE
 > thing is hopefully only enabled in debug kernels (like maybe the
 > Fedora rawhide one

Nope. After spending a couple of days fruitlessly trying to get my machine to boot
with it enabled, I think we decided it's not worth the pain.  Debugging
"hangs instantly and silently on boot" bugs are hard enough when you're in front of the machine,
doing so via bugzilla isn't something I'd wish on my worst enemy.

	Dave

