Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3E0Rus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab3E0Rur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:50:47 -0400
Message-ID: <51A39CEE.9030303@redhat.com>
Date: Mon, 27 May 2013 13:50:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] ipc/sem.c: Bug fixes, regression fixes, v3
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com> <20130527020459.GA7365@kroah.com>
In-Reply-To: <20130527020459.GA7365@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 10:04 PM, Greg KH wrote:
> On Sun, May 26, 2013 at 11:08:51AM +0200, Manfred Spraul wrote:
>> I've split my patch into 4 parts:
>> - 1: Fix-missing-wakeups-in-do_smart_update
>> - 2: seperate-wait-for-zero-and-alter-tasks
>> - 3: Always-use-only-one-queue-for-alter-operations
>> - 4: Rename-try_atomic_semop-to-perform_atomic
>>
>> Linus:
>> - Patch 1 should be merged immediately: It fixes bugs,
>>    the current code misses wakeups.
>
> Should this patch be backported to 3.9 and maybe older kernels as well?

No need, the new semaphore code (with this last regression)
did not get merged until the 3.10 merge window.

