Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3BUPuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:50:50 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:59515 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3BUPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:50:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAC4Lta2DsH_0GtoeaW_6tz5YXO5wFkQuWqwszihCLs65a7XY0g@mail.gmail.com>
References: <20130220022712.0E8586607A4@gitolite.kernel.org>
	<CAKocOOMo-5Hiv_dBCpZNYMP_wXWiWugBYq4qsRcMBwm=TPM=dA@mail.gmail.com>
	<20130221085654.GB23223@gmail.com>
	<CAC4Lta2DsH_0GtoeaW_6tz5YXO5wFkQuWqwszihCLs65a7XY0g@mail.gmail.com>
Date: Thu, 21 Feb 2013 08:50:48 -0700
Message-ID: <CAKocOOP5kV=dBr9eya3DtysggSHHpTfJfpPbpyMNf4==_H23+Q@mail.gmail.com>
Subject: Re: sched: Fix signedness bug in yield_to()
From: Shuah Khan <shuahkhan@gmail.com>
To: Raghavendra KT <raghavendra.kt.linux@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        dan.carpenter@oracle.com, peterz@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 3:05 AM, Raghavendra KT
<raghavendra.kt.linux@gmail.com> wrote:
> On Thu, Feb 21, 2013 at 2:26 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Shuah Khan <shuahkhan@gmail.com> wrote:
>>
>>> On Tue, Feb 19, 2013 at 7:27 PM, Linux Kernel Mailing List
>>> <linux-kernel@vger.kernel.org> wrote:
>>> > Gitweb:     http://git.kernel.org/linus/;a=commit;h=c3c186403c6abd32e719f005f0af950155a9e54d
>>> > Commit:     c3c186403c6abd32e719f005f0af950155a9e54d
>>> > Parent:     e0a79f529d5ba2507486d498b25da40911d95cf6
>>> > Author:     Dan Carpenter <dan.carpenter@oracle.com>
>>> > AuthorDate: Tue Feb 5 14:37:51 2013 +0300
>>> > Committer:  Ingo Molnar <mingo@kernel.org>
>>> > CommitDate: Tue Feb 5 12:59:29 2013 +0100
>>> >
>>> >     sched: Fix signedness bug in yield_to()
>>> >
>>> >     In 7b270f6099 "sched: Bail out of yield_to when source and
>>> >     target runqueue has one task" we changed this to store -ESRCH so
>>> >     it needs to be signed.
>>>
>>> Dan, Ingo,
>>>
>>> I can't find the 7b270f6099 "sched: Bail out of yield_to when
>>> source and target runqueue has one task" in the latest Linus's
>>> git. Am I missing something.
>>>
>>> The current kenel/sched/core.c doesn't have the code from the
>>> associated patch https://patchwork.kernel.org/patch/2016651/
>>
>> As per the lkml discussion that one was supposed to go upstream
>> via the KVM tree. Marcelo?
>>
>
> It is going via KVM tree. (as per Gleb's pull request)

Thanks. Do you see these two commits as stable release candidates?

-- Shuah
