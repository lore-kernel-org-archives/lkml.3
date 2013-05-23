Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab3EWROD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:14:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360Ab3EWROA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:14:00 -0400
Date: Thu, 23 May 2013 20:13:58 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM fixes for 3.10-rc2
Message-ID: <20130523171358.GN26157@redhat.com>
References: <20130523104105.GA6826@redhat.com>
 <CA+55aFxA8AJLi3gvHKVuNdR+Yu2ZGRAbLnxTL4BVo6vY3fRYxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxA8AJLi3gvHKVuNdR+Yu2ZGRAbLnxTL4BVo6vY3fRYxA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 09:20:22AM -0700, Linus Torvalds wrote:
> On Thu, May 23, 2013 at 3:41 AM, Gleb Natapov <gleb@redhat.com> wrote:
> >
> >  MAINTAINERS                      |    7 ++--
> >  arch/mips/include/asm/kvm.h      |   55 ---------------------------------------
> >  arch/mips/include/uapi/asm/kvm.h |   55 +++++++++++++++++++++++++++++++++++++++
> >  arch/mips/kvm/kvm_tlb.c          |   35 ++++++++++++++++++------
> >  4 files changed, 85 insertions(+), 67 deletions(-)
> 
> This was wrong. Please make sure you use the "-M" flag to make git
> diff look for file renames, and the "--summary" flag to show metadata
> changes separately.
> 
> IOW, it *should* have looked like this:
> 
>  MAINTAINERS                            |  7 ++++---
>  arch/mips/include/{ => uapi}/asm/kvm.h |  0
>  arch/mips/kvm/kvm_tlb.c                | 35 ++++++++++++++++++++++++++---------
>  3 files changed, 30 insertions(+), 12 deletions(-)
>  rename arch/mips/include/{ => uapi}/asm/kvm.h (100%)
> 
Ugh, yes "-M" and "--summary" were missing. I updated the script now. Thanks!
Should I regenerate pull request?

--
			Gleb.
