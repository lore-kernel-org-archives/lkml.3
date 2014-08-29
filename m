Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaH2TVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:21:47 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33386 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbaH2TVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <540032AF.5080504@redhat.com>
References: <1408401967-27211-1-git-send-email-dmatlack@google.com>
 <1408401967-27211-2-git-send-email-dmatlack@google.com> <CALzav=fCgNRbfPBxzYR7RL0f8w3qU8h3ZQTRU=P9-djo7fRJ3g@mail.gmail.com>
 <540032AF.5080504@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 29 Aug 2014 12:21:23 -0700
Message-ID: <CALzav=fGNUPX5aNHjm8UkOy_PBMdV78CckmGHurByDDGcsCuDw@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: x86: fix stale mmio cache bug
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kivity <avi.kivity@gmail.com>, mtosatti@redhat.com,
        stable@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 12:58 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 28/08/2014 23:10, David Matlack ha scritto:
>> Paolo,
>> It seems like this patch ("[PATCH 2/2] kvm: x86: fix stale mmio cache")
>> is ready to go. Is there anything blocking it from being merged?
>>
>> (It should be fine to merge this on its own, independent of the fix
>> discussed in "[PATCH 1/2] KVM: fix cache stale memslot info with
>> correct mmio generation number", https://lkml.org/lkml/2014/8/14/62.)
>
> I'll post the full series today.  Sorry, I've been swamped a bit.

Thanks, I'll start testing it. Hope things quiet down for you soon :)

>
> Paolo
