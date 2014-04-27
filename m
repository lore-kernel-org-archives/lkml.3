Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaD0AP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 20:15:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43445 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaD0AP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 20:15:26 -0400
Message-ID: <535C4C1A.5070101@infradead.org>
Date: Sat, 26 Apr 2014 17:15:22 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Moskyto Matejka <mq@suse.cz>
CC: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: fix documentation for /proc/stat, line "intr"
References: <1398180580-8089-1-git-send-email-mq@suse.cz> <5356B2AB.3020005@gmail.com> <5356EEBB.5040402@infradead.org> <20140423094836.GA10953@moskyto.dyndns.org>
In-Reply-To: <20140423094836.GA10953@moskyto.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/14 02:48, Jan Moskyto Matejka wrote:
> n Tue, Apr 22, 2014 at 03:35:39PM -0700, Randy Dunlap wrote:
>> On 04/22/14 11:19, Michael Kerrisk (man-pages) wrote:
>>> On 04/22/2014 05:29 PM, Jan Moskyto Matejka wrote:
>>>> The sum at the beginning of line "intr" includes also unnumbered interrupts.
>>>> It implies that the sum at the beginning isn't the sum of the remainder of the
>>>> line, not even an estimation.
>>>>
>>>> Fixed the documentation to mention that.
>>>
>>> I'm not really doubting what you claim, Jan, but it would be really
>>> helpful if you provided some data to support the proposed change
>>> (Kernel source references, or notes about testing you've done, or 
>>> pointers to mailing list threads, authoritative note that you are
>>> the maintainer of some relevant kernel subsystem...). Do you have
>>> something like that? (It's also useful for the change log.)
>>
>> I wouldn't mind more of a changelog, but the additional text is
>> certainly correct.
>>
>> Thanks.  I'll apply the patch, but more changelog comments are welcome.
> 
> Thank you for applying.
> 
> You may add following line to the changelog:
> This behaviour was added to /proc/stat in commit a2eddfa95919a730e0e5ed17e9c303fe5ba249cd.
> 
> MQ
> 

I added that and applied your patch.  Thanks.

-- 
~Randy
