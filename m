Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaIXRRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:17:25 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:59932 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaIXRRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:17:23 -0400
MIME-Version: 1.0
In-Reply-To: <5422808B.5070002@redhat.com>
References: <1411410865-3603-1-git-send-email-andreslc@google.com>
	<1411422882-16245-1-git-send-email-andreslc@google.com>
	<20140924022729.GA2889@kernel>
	<54226CEB.9080504@redhat.com>
	<542270BA.4090708@gmail.com>
	<5422808B.5070002@redhat.com>
Date: Wed, 24 Sep 2014 10:17:22 -0700
Message-ID: <CAJu=L59r-9GjZBmbQwWzJwnJMMJ5o-vWPXgA1Rv9bAwf1zywCw@mail.gmail.com>
Subject: Re: [PATCH v4] kvm: Fix page ageing bugs
From: Andres Lagar-Cavilla <andreslc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <kernellwp@gmail.com>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 1:27 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 24/09/2014 09:20, Wanpeng Li ha scritto:
>>
>> This trace point still dup duplicated message for the same gfn in the
>> for loop.
>
> Yes, but the gfn argument lets you take it out again.
>
> Note that having the duplicated trace would make sense if you included
> the accessed bit for each spte, instead of just the "young" variable.

FWIW the new arrangement in kvm.git/queue LGTM

Thanks
Andres

>
> Paolo



-- 
Andres Lagar-Cavilla | Google Kernel Team | andreslc@google.com
