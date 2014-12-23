Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbaLWIRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:17:18 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:60687 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbaLWIRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:17:17 -0500
MIME-Version: 1.0
In-Reply-To: <549917F6.1080504@redhat.com>
References: <cover.1419295081.git.luto@amacapital.net> <549917F6.1080504@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 23 Dec 2014 00:16:55 -0800
Message-ID: <CALCETrUtf=a9wRYwftJxNB6Smrf0pXS43qPd37XO0_mxrGJ-Cg@mail.gmail.com>
Subject: Re: [RFC 0/2] x86, vdso, pvclock: Cleanups and speedups
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        glommer@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:21 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 23/12/2014 01:39, Andy Lutomirski wrote:
>> This is a dramatic simplification and speedup of the vdso pvclock read
>> code.  Is it correct?
>>
>> Andy Lutomirski (2):
>>   x86, vdso: Use asm volatile in __getcpu
>>   x86, vdso, pvclock: Simplify and speed up the vdso pvclock reader
>
> Patch 1 is ok,
>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Any thoughts as to whether it should be tagged for stable?  I haven't
looked closely enough at the old pvclock code or the generated code to
have much of an opinion there.  It'll be a big speedup for non-pvclock
users at least.

--Andy

>
> For patch 2 I will defer to Marcelo and Glauber (and the Xen folks).
>
> Paolo



-- 
Andy Lutomirski
AMA Capital Management, LLC
