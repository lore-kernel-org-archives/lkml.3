Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3LJIRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:17:14 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:47605 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3LJIQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:16:58 -0500
MIME-Version: 1.0
In-Reply-To: <CABawtvPdQ2smcawTywp605KceKAQF+CsvpBqG1zEaKfP-PLB6A@mail.gmail.com>
References: <1386495533-413-1-git-send-email-ethan.kernel@gmail.com>
	<00000142d82085d4-edeac9e1-d603-458f-9ceb-904e2b706679-000000@email.amazonses.com>
	<CABawtvPdQ2smcawTywp605KceKAQF+CsvpBqG1zEaKfP-PLB6A@mail.gmail.com>
Date: Tue, 10 Dec 2013 16:16:56 +0800
Message-ID: <CABawtvM6MpwHH7kFjnqSr69QWboFXsEiu6Fv0MMJkhQbaXCLxw@mail.gmail.com>
Subject: Re: [PATCH] mm/slab.c: check pointer slabp before using it in alloc_slabmgmt()
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: alokk@calsoftinc.com, shobhit@calsoftinc.com, shai@scalex86.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

     No, stable 3.12.4 and 3.12.3 need this patch.  3.13RC doesn't
need it anymore.

Thanks,
Ethan

On Tue, Dec 10, 2013 at 3:08 PM, Ethan Zhao <ethan.kernel@gmail.com> wrote:
> Christoph,
>     Found in the latest stable release V3.12.3,  yes, changed in
> 3.12.4. not needed for later release anymore.
>
> Thanks,
> Ethan
>
>
> On Tue, Dec 10, 2013 at 12:11 AM, Christoph Lameter <cl@linux.com> wrote:
>> On Sun, 8 Dec 2013, ethan.zhao wrote:
>>
>>> Move the NULL check of slabp to the right place before refer its memeber in
>>> function alloc_slabmgmt().
>>
>> I am having trouble to find the code you are modifying. Which kernel
>> release is this? The code you are referring to has been rewritten in the
>> meantime or this is some other code basis.
>>
