Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbaGVRko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:40:44 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:57095 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbaGVRkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:40:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBb+fnCNeQtyEqttxbkWx-4N+GUaKCUoCSdn5X9+bDDvTOg@mail.gmail.com>
References: <1406004789-9918-1-git-send-email-xerofoify@gmail.com>
	<874my98p6u.fsf@nemi.mork.no>
	<CA+8MBb+fnCNeQtyEqttxbkWx-4N+GUaKCUoCSdn5X9+bDDvTOg@mail.gmail.com>
Date: Tue, 22 Jul 2014 13:40:42 -0400
Message-ID: <CAPDOMVjaf+vne4vbUPo8EPs0XnQBbNm2ZOXns8fw5pkg9tRSww@mail.gmail.com>
Subject: Re: [PATCH] edac: Remove fixmes in e7xxx_edac.c
From: Nick Krause <xerofoify@gmail.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 1:25 PM, Tony Luck <tony.luck@gmail.com> wrote:
> On Tue, Jul 22, 2014 at 7:04 AM, Bjørn Mork <bjorn@mork.no> wrote:
>>> -     /* FIXME - should use PAGE_SHIFT */
>>> -     page = error_1b >> 6;   /* convert the address to 4k page */
>>> +     page = error_1b >> PAGE_SHIFT;  /* convert the address to 4k page */
>>
>> I just have to bite...  Where did you get the idea that you can go
>> around and "fix" FIMXE's like they were spelling errors?
>
> Or apparently without thinking? Since "PAGE_SHIFT" does not have
> the numerical value "6" your new code is obviously not equivalent to
> the old.
>
> -Tony

Tony,

What is the value of Page shift then ? If you can tell me it would be
much easier for
me to fix this.
Cheers Nick
