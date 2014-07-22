Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbaGVTSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:18:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaGVTSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:18:13 -0400
Message-ID: <53CEB8DB.1000301@infradead.org>
Date: Tue, 22 Jul 2014 12:17:47 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>, Levente Kurusa <lkurusa@redhat.com>
CC: Tony Luck <tony.luck@gmail.com>,
        =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Remove fixmes in e7xxx_edac.c
References: <1406004789-9918-1-git-send-email-xerofoify@gmail.com>	<874my98p6u.fsf@nemi.mork.no>	<CA+8MBb+fnCNeQtyEqttxbkWx-4N+GUaKCUoCSdn5X9+bDDvTOg@mail.gmail.com>	<CAPDOMVjaf+vne4vbUPo8EPs0XnQBbNm2ZOXns8fw5pkg9tRSww@mail.gmail.com>	<CAAsK9AGtdJiz0xnmfqLBAqxmt=r+WANsmxwB_vQ3O5aKzMW1LQ@mail.gmail.com> <CAPDOMVhj72TFKbtw_93juX19WVdfUzh3KM9tCEjbTdUZvUfcUQ@mail.gmail.com>
In-Reply-To: <CAPDOMVhj72TFKbtw_93juX19WVdfUzh3KM9tCEjbTdUZvUfcUQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 11:25 AM, Nick Krause wrote:
> On Tue, Jul 22, 2014 at 2:14 PM, Levente Kurusa <lkurusa@redhat.com> wrote:
>> 2014-07-22 19:40 GMT+02:00 Nick Krause <xerofoify@gmail.com>:
>>> [...]
>>>
>>> Tony,
>>>
>>> What is the value of Page shift then ? If you can tell me it would be
>>> much easier for
>>> me to fix this.
>>> Cheers Nick
>>
>> Nick,
>>
>> Help is always welcome. However, what you are doing is effectively a
>> waste of time for you and for the maintainers as well, and hence cannot
>> be called help. You are writing emails that make absolutely no sense at all.
>> If you want to help us out, please consider learning three things:
>>
>> * The language that the kernel is written in: C
>> * The language that most kernel developers understand: English
>> * The environment the kernel is (in most cases) written in: UNIX
>>
>> If you had known these, then:
>>
>> * ... you would have already known that FIXMEs exist for a reason which is
>>    not at all simple.
>>
>> * ... you would have understood that fixing FIXMEs without ANY reasoning and
>>    asking about it is completely useless and wastes precious maintainer time.
>>
>> * ... you could have used grep for finding out PAGE_SHIFT and not need to ask
>>    for it.
>>
>> Nick. Look, it is good that you are enthusiastic. However, this kind
>> of 'work' gives
>> you an undesirable reputation, which is {IF FROM:xerofoify@* THEN TRASH}...
>>
>> If you really want to help out, I suggest you to find yourself a piece
>> of hardware from
>> the store and try to write a driver for it. That way, you will learn
>> how it all works, and if
>> you are intelligent enough then you might get a "Kernel Job - Payed"
>> like you asked us
>> for them in November.
>>
>> Until then, please stop trying for FIXMEs. They will not get you a
>> commit in the kernel
>> 99% of the time.
>>
>> Hope you understand,
>>
>> Levente Kurusa
> 
> 
> Levente,
> 
> I understand what your saying and I should have searched for Page shift.

so you know that PAGE_SHIFT is not always 12?

> In addition I am already got commits in the kernel for fix mes so I feel
> that your comment on fix mes is incorrect.

what is your goal?


-- 
~Randy
