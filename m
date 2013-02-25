Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516Ab3BYAFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 19:05:33 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:40063 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759413Ab3BYAFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 19:05:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130221011702.GA791@amt.cnet>
References: <20130221011702.GA791@amt.cnet>
Date: Sun, 24 Feb 2013 16:05:31 -0800
X-Google-Sender-Auth: 5fz1cw3kQ2jHeXQng_WE_siTc1Y
Message-ID: <CA+55aFy_SMKQ27JR6iO5GcNKaTR0aRZm8BKtJ+0gUibXeCLBUQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for the 3.9 merge window
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 5:17 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> Please pull from
>
> git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.9-1
>
> to receive the KVM updates for the 3.9 merge window [..]

Ok, particularly the s390 people should check me resolution of the
conflicts, since they include the renaming of IOINT_VIR to IRQIO_VIR.
But the uapi header file move should be couble-checked by people who
use this too.

                 Linus
