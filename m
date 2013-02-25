Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab3BYLVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:21:39 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:51472 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3BYLVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:21:37 -0500
Date: Mon, 25 Feb 2013 12:21:28 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] KVM updates for the 3.9 merge window
Message-ID: <20130225122128.7eb40d9f@mschwide>
In-Reply-To: <CA+55aFy_SMKQ27JR6iO5GcNKaTR0aRZm8BKtJ+0gUibXeCLBUQ@mail.gmail.com>
References: <20130221011702.GA791@amt.cnet>
	<CA+55aFy_SMKQ27JR6iO5GcNKaTR0aRZm8BKtJ+0gUibXeCLBUQ@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022511-5024-0000-0000-0000054C6156
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013 16:05:31 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Feb 20, 2013 at 5:17 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >
> > Please pull from
> >
> > git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.9-1
> >
> > to receive the KVM updates for the 3.9 merge window [..]
> 
> Ok, particularly the s390 people should check me resolution of the
> conflicts, since they include the renaming of IOINT_VIR to IRQIO_VIR.
> But the uapi header file move should be couble-checked by people who
> use this too.

The IRQIO_VIR is now at the end of the IRQIO_xxx entries while we had
it between the IRQIO_CSC and the IRQIO_PCI entry. No worry, we just
change our code and use the upstream version. Just completed the
double-check and pushed my branches to the linux-s390 tree. The code
is in sync.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

