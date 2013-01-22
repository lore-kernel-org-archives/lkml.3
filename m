Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3AVQOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:14:52 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:45470 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab3AVQOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:14:51 -0500
MIME-Version: 1.0
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
	<CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
Date: Tue, 22 Jan 2013 09:14:49 -0700
Message-ID: <CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
Subject: Re: Linux 3.8-rc4
From: Shuah Khan <shuahkhan@gmail.com>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 9:44 AM, Deucher, Alexander
<Alexander.Deucher@amd.com> wrote:
>> -----Original Message-----
>> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>> Sent: Friday, January 18, 2013 7:40 PM
>> To: Linus Torvalds; Deucher, Alexander
>> Cc: Linux Kernel Mailing List
>> Subject: Re: Linux 3.8-rc4
>>
>> On Fri, Jan 18, 2013 at 3:37 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
>> > On Fri, Jan 18, 2013 at 10:51 AM, Shuah Khan <shuahkhan@gmail.com>
>> wrote:
>>
>> >
>> > ok. I bisected the DMAR faults and it points to the following commit:
>> >
>> > 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb
>> >
>> > This commit as I recall, fixed the crash problem I was seeing back in
>> > 3.8-rc1. Reverting to see if crash problem reappears.
>>
>> Confirming that with this commit reverted crash problem re-appeared.
>> With this commit, DMAR faults show up.
>
> I'm not quite sure what's going on with your system.   At this point it's probably best to just disable the DMA ring on these cards until we sort out what's going on.  The attached patch disables the use of the DMA ring.  Let me know if it fixes the issues you are seeing.
>

I applied this patch to 3.8-rc4 and didn't fix the DMAR faults.

-- Shuah
