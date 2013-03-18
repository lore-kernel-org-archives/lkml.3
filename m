Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab3CRCpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:45:23 -0400
Received: from ozlabs.org ([203.10.76.45]:35689 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3CRCpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:45:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the signal tree with the modules tree
In-Reply-To: <CA+icZUUiGeUcbjphz6sY=1oA194a1MQN_FOpkm4=BVNXKmQmfA@mail.gmail.com>
References: <20130314172737.2856af8a9b368bc395d977be@canb.auug.org.au> <87li9ptgtq.fsf@rustcorp.com.au> <CA+icZUUiGeUcbjphz6sY=1oA194a1MQN_FOpkm4=BVNXKmQmfA@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 18 Mar 2013 11:26:54 +1030
Message-ID: <87vc8psey1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> writes:
> On Fri, Mar 15, 2013 at 5:41 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>>> Hi Al,
>>>
>>> Today's linux-next merge of the signal tree got a conflict in
>>> include/asm-generic/unistd.h between commit 837718bfd28b
>>> ("CONFIG_SYMBOL_PREFIX: cleanup") from the modules tree and commit
>>> e1b5bb6d1236 ("consolidate cond_syscall and SYSCALL_ALIAS declarations")
>>> from the signal tree.
>>>
>>> The latter moved the cond_syscall stuff to linkage.h, so I applied the
>>> following patch as a merge fixup and can carry the fix as necessary (no
>>> action is required).  I am not sure if this is completely correct or all
>>> that is needed.
>>
>> Your fix looks correct, thanks.
>>
>> I've been forced to update that patch after another round of
>> improvements, so you may need to re-do the merge.
>>
>
> Hi,
>
> I just looked into modules-next...
> The improved version is in [1]...
> ...and contains a file called "kernel/modsign_certificate.S" which is
> NOT in the latest Linux-Next tree [2].
> So, I thought about reverting the one in -next and apply the new one
> from modules-next.
> This is not possible!

I'd wait until Stephen has done the new merge, which should happen
within 12 hours from now.

Thanks,
Rusty.
