Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761211Ab3EALT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 07:19:58 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39242 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab3EALTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 07:19:50 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXqmF5QcfVtGpEh5KX4OkgbUncyZB0DKixqSNquUpis1A@mail.gmail.com>
References: <20130425232702.AF3D831C265@corp2gmr1-1.hot.corp.google.com>
	<CA+icZUXqmF5QcfVtGpEh5KX4OkgbUncyZB0DKixqSNquUpis1A@mail.gmail.com>
Date: Wed, 1 May 2013 13:19:48 +0200
Message-ID: <CA+icZUXOr90HvhrLd3rhu+uph1=t4LLL=aAPDHqHYzSHDDRKYQ@mail.gmail.com>
Subject: Re: mmotm 2013-04-25-16-24 uploaded
From: Sedat Dilek <sedat.dilek@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 2:05 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Apr 26, 2013 at 1:27 AM,  <akpm@linux-foundation.org> wrote:
>> The mm-of-the-moment snapshot 2013-04-25-16-24 has been uploaded to
>>
>>    http://www.ozlabs.org/~akpm/mmotm/
>>
>
> Hi Andrew,
>
> Nice to see that IPC-SEM is now safe again with Linux-Next (next-20130426).
>
> Affected patches...
>
> ipcsem-fine-grained-locking-for-semtimedop-do-not-call-sem_lock-when-bogus-sma.patch
> ipcsem-fine-grained-locking-for-semtimedop-fix-lockdep-false-positive.patch
> ipcsem-fine-grained-locking-for-semtimedop-fix-locking-in-semctl_main.patch
> ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic-fix.patch
> ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic.patch
> ipcsem-fine-grained-locking-for-semtimedop-untangle-rcu-locking-with-find_alloc_undo.patch
>
> Just see one patch has my Tested-by (Reported-by) ...
>
> All these 6 ipc-sem-next patches were tested several times by me.
>
> It took me approx 2 weeks and XX kernel-builds.
> Please gimme appropriate credits, Thanks.
>

Today I got several mails on IPC-SEM stuff with CCs to me and
Tested-by/Reported-by.
All credits were given/respected.
Thanks.

Hope I could help.

- Sedat -

> Have a nice weekend,
> - Sedat -
>
> P.S.: Check for Sedat's credits.
>
> ipcsem-fine-grained-locking-for-semtimedop-fix-lockdep-false-positive.patch:Cc:
> Sedat Dilek <sedat.dilek@gmail.com>
>
> ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic.patch:Sedat
> reported an issue leading to a NULL dereference in update_queue():
> ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic.patch:Tested-by:
> Sedat Dilek <sedat.dilek@gmail.com>
>
> ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic.patch:Reported-by:
> Sedat Dilek <sedat.dilek@gmail.com>
>
> ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic.patch:Cc:
> Sedat Dilek <sedat.dilek@gmail.com>
