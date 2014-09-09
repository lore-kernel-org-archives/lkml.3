Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbaIIRkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:40:43 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49148 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaIIRkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:40:40 -0400
Message-ID: <540F3B96.9050809@zankel.net>
Date: Tue, 09 Sep 2014 10:40:38 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Max Filippov <jcmvbkbc@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/2] xtensa/uapi: Add definition of TIOC[SG]RS485
References: <1410240056-22786-1-git-send-email-ricardo.ribalda@gmail.com> <CAMo8BfJRO+dwMVDJiQ4KH0PdJN604YrrZZUdSK35KumE574uyg@mail.gmail.com> <CAPybu_0w0+Ez1BUUm6PNwN4gv5w7EqE7YL3F3AvDWVtQ8a_UrA@mail.gmail.com>
In-Reply-To: <CAPybu_0w0+Ez1BUUm6PNwN4gv5w7EqE7YL3F3AvDWVtQ8a_UrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ricardo,

I'll add it to the xtensa-next tree today..

Thanks,
-Chris

On 9/9/14, 10:32 AM, Ricardo Ribalda Delgado wrote:
> Hello Max
>
> I really don't know who should do it, the maintainer of tty-next or
> you :). I guess Greg will want that his is fixed on his tree asap,
> since that build is broken.
>
> Lets give him some time to reply, if nothing happens, then please
> apply it through your tree.
>
>
> Best regards
>
> On Tue, Sep 9, 2014 at 5:24 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
>> On Mon, Sep 8, 2014 at 10:20 PM, Ricardo Ribalda Delgado
>> <ricardo.ribalda@gmail.com> wrote:
>>> Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 [3/21] serial/8250: Add
>>> support for RS485 IOCTLs, adds support for RS485 ioctls for 825_core on
>>> all the archs. Unfortunaltely the definition of TIOCSRS485 and
>>> TIOCGRS485 was missing on the ioctls.h file
>>>
>>> Reported-by: kbuild test robot <fengguang.wu@intel.com>
>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>> ---
>>>   arch/xtensa/include/uapi/asm/ioctls.h | 2 ++
>>>   1 file changed, 2 insertions(+)
>> Acked-by: Max Filippov <jcmvbkbc@gmail.com>
>>
>> If you want this patch to go through the xtensa tree please let me know,
>> I'll include it to my fixes branch then.
>>
>> --
>> Thanks.
>> -- Max
>
>

