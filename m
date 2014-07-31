Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaGaDc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 23:32:58 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:44244 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbaGaDc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 23:32:57 -0400
MIME-Version: 1.0
In-Reply-To: <53D9B482.8070306@gmail.com>
References: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
	<CA+WRLO9HdX=PDktUci2bQNM0Wp6DsjxiiWBNAxOtvitPqWDCAg@mail.gmail.com>
	<CAPDOMVjxx0WXVXVrMLgO1FimHNrJTn0Dp14G9_dXhSrm32WyBQ@mail.gmail.com>
	<53D9B482.8070306@gmail.com>
Date: Wed, 30 Jul 2014 23:32:56 -0400
Message-ID: <CAPDOMVi_HUQsoEF_XHdPHrQVmMNbje5_wxd0=Ev5j59qB22jag@mail.gmail.com>
Subject: Re: Work Queue for btrfs compression writes
From: Nick Krause <xerofoify@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:14 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 07/30/2014 12:54 AM, Nick Krause wrote:
>> On Wed, Jul 30, 2014 at 12:37 AM, Gareth Pye <gareth@cerberos.id.au> wrote:
>>> You've been replied to politely, now listen and do or shut up.
>>>
>>>
>>> On Wed, Jul 30, 2014 at 1:54 PM, Nick Krause <xerofoify@gmail.com> wrote:
>>>>
>>>> Hey Guys ,
>>>> I am new to   reading  and writing  kernel code.I got interested in
>>>> writing code for btrfs as it seems to
>>>> need more work then other file systems and this seems other then
>>>> drivers, a good use of time on my part.
>>>> I interested in helping improving the compression of btrfs by using  a
>>>> set of threads using work queues like XFS
>>>> or reads and keeping the page cache after reading compressed blocks as
>>>> these seem to be a great way to improve
>>>> on  compression performance mostly with large partitions of compressed
>>>> data. I am not asking you to write the code
>>>> for me but as I am new a little guidance and help would be greatly
>>>> appreciated as this seems like too much work for just a newbie.
>>>> Thanks A lot,
>>>> Nick
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>>
>>> --
>>> Gareth Pye
>>> Level 2 Judge, Melbourne, Australia
>>> Australian MTG Forum: mtgau.com
>>> gareth@cerberos.id.au - www.rockpaperdynamite.wordpress.com
>>> "Dear God, I would like to file a bug report"
>>
>> Gareth
>> I am asking for advice on not writing the code but can someone please
>> test this for me as I don't have many hard drives lying around. In addition
>> I am new to btrfs , so I would like to known if this is a good idea or should
>> I just drop it?
>> Nick
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> I would look into using usermode linux (linux built with ARCH=um) for at
> least the initial debugging, it is marginally more efficient than
> virtualization, doesn't need root privileges, and allows you to run the
> kernel under GDB without needing separate hardware with a serial console
> or PS/2 keyboard.
>

That's what I am thinking the only issue is I am going to start my
reading on work queues first.
Regards Nick
