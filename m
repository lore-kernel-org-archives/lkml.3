Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaH2H6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:58:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaH2H6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:58:51 -0400
Message-ID: <540032AF.5080504@redhat.com>
Date: Fri, 29 Aug 2014 09:58:39 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Matlack <dmatlack@google.com>
CC: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kivity <avi.kivity@gmail.com>, mtosatti@redhat.com,
        stable@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] kvm: x86: fix stale mmio cache bug
References: <1408401967-27211-1-git-send-email-dmatlack@google.com> <1408401967-27211-2-git-send-email-dmatlack@google.com> <CALzav=fCgNRbfPBxzYR7RL0f8w3qU8h3ZQTRU=P9-djo7fRJ3g@mail.gmail.com>
In-Reply-To: <CALzav=fCgNRbfPBxzYR7RL0f8w3qU8h3ZQTRU=P9-djo7fRJ3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/08/2014 23:10, David Matlack ha scritto:
> Paolo,
> It seems like this patch ("[PATCH 2/2] kvm: x86: fix stale mmio cache")
> is ready to go. Is there anything blocking it from being merged?
> 
> (It should be fine to merge this on its own, independent of the fix
> discussed in "[PATCH 1/2] KVM: fix cache stale memslot info with
> correct mmio generation number", https://lkml.org/lkml/2014/8/14/62.)

I'll post the full series today.  Sorry, I've been swamped a bit.

Paolo
