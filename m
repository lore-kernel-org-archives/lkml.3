Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706Ab3EWQUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:20:25 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:40056 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028Ab3EWQUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:20:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130523104105.GA6826@redhat.com>
References: <20130523104105.GA6826@redhat.com>
Date: Thu, 23 May 2013 09:20:22 -0700
X-Google-Sender-Auth: 3oYYWwK7dqGBO7en5yCOVaIrHwc
Message-ID: <CA+55aFxA8AJLi3gvHKVuNdR+Yu2ZGRAbLnxTL4BVo6vY3fRYxA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fixes for 3.10-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 3:41 AM, Gleb Natapov <gleb@redhat.com> wrote:
>
>  MAINTAINERS                      |    7 ++--
>  arch/mips/include/asm/kvm.h      |   55 ---------------------------------------
>  arch/mips/include/uapi/asm/kvm.h |   55 +++++++++++++++++++++++++++++++++++++++
>  arch/mips/kvm/kvm_tlb.c          |   35 ++++++++++++++++++------
>  4 files changed, 85 insertions(+), 67 deletions(-)

This was wrong. Please make sure you use the "-M" flag to make git
diff look for file renames, and the "--summary" flag to show metadata
changes separately.

IOW, it *should* have looked like this:

 MAINTAINERS                            |  7 ++++---
 arch/mips/include/{ => uapi}/asm/kvm.h |  0
 arch/mips/kvm/kvm_tlb.c                | 35 ++++++++++++++++++++++++++---------
 3 files changed, 30 insertions(+), 12 deletions(-)
 rename arch/mips/include/{ => uapi}/asm/kvm.h (100%)

Thanks,

           Linus
