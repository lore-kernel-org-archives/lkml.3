Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaIBRTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:19:00 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38650 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaIBRS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:18:58 -0400
MIME-Version: 1.0
In-Reply-To: <5405F53A.4000705@redhat.com>
References: <1409308277-4021-1-git-send-email-pbonzini@redhat.com>
 <5405E550.1010201@redhat.com> <CALzav=ceAVpR7kq-K2eX17s9LgC7_ddt83W8yYc_f=zN8Kh6sg@mail.gmail.com>
 <5405F53A.4000705@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 2 Sep 2014 10:18:37 -0700
Message-ID: <CALzav=fm=unEjYsHbBT_SA7g-NmggBK7ubqw9dU8LK5eFRWhmQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] fix bugs with stale or corrupt MMIO caches
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 9:50 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 02/09/2014 18:47, David Matlack ha scritto:
>>> > Ping?
>> Sorry for the delay. I think the patches look good. And patch 3/3 still
>> fixes the bug I was originally seeing, so I'm happy :). I just had one
>> small comment (see my reply to patch 2/3).
>>
>
> I answered that question now.  Can I add your Reviewed-by and, for patch
> 3, Tested-by?

Please do. And thanks again for working on these!

>
> Paolo
