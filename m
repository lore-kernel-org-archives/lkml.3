Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3DOD0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:26:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52947 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab3DOD0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:26:43 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQUGxGveg__VHE0-f0zfuY1ivuDMpQmMb9p0ic5=Hyf91A@mail.gmail.com>
References: <1365749691-21299-1-git-send-email-yinghai@kernel.org> <1365749691-21299-2-git-send-email-yinghai@kernel.org> <516B5F1F.1040106@zytor.com> <CAE9FiQUGxGveg__VHE0-f0zfuY1ivuDMpQmMb9p0ic5=Hyf91A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 1/4] x86, kdump: Set crashkernel_low automatically
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 14 Apr 2013 20:26:12 -0700
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <9c406d9c-e69c-4d09-bdfc-6cecb53f373a@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then make the comment so it is actually possible to understand that.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Sun, Apr 14, 2013 at 6:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 04/11/2013 11:54 PM, Yinghai Lu wrote:
>>
>>> +             /*
>>> +              * two parts from lib/swiotlb.c:
>>> +              *      swiotlb size: user specified with swiotlb= or
>default.
>>> +              *      swiotlb overflow buffer: now is hardcoded to
>32k,
>>> +              *              round to 8M to cover more others.
>>> +              */
>>
>> This comment is incomprehensible.  "Cover more others"?
>
>i mean other buffers that may need to stay low, but we do not know
>them eactly yet.
>
>Thanks
>
>Yinghai

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
