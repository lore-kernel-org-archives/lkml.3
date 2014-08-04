Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaHDOpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:45:24 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:34537 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaHDOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:45:22 -0400
MIME-Version: 1.0
In-Reply-To: <53DF98D7.7030106@gmail.com>
References: <Pine.LNX.4.44L0.1408041007330.1169-100000@iolanthe.rowland.org>
	<53DF98D7.7030106@gmail.com>
Date: Mon, 4 Aug 2014 16:45:21 +0200
Message-ID: <CAFLxGvyob4hxW36McgCY=DjnoWqdGt7xzyugyUq0sT++_VXD=A@mail.gmail.com>
Subject: Re: Kernel Debugging Support
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 4:29 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2014-08-04 10:21, Alan Stern wrote:
>> On Mon, 4 Aug 2014, Austin S Hemmelgarn wrote:
>>
>>> On 2014-08-02 09:48, Alan Stern wrote:
>>>> On Sat, 2 Aug 2014, Nick Krause wrote:
>>>>
>>>>> Hey Sharp,
>>>>> After reading around seems people want support for usb debugging in
>>>>> kgdb or other usb based solutions.
>>>>> If you and the other developers are able to help me out a bit as I am
>>>>> new I can definitively write this
>>>>> area of kgdb support.
>>>>
>>>> Doesn't kgdb already support USB for debugging?
>>>>
>>>> Alan Stern
>>>
>>> AFAICT, on x86 it only supports using either a console capable serial
>>> port (so you could do that over USB if you have USB serial console
>>> support built-in, but most people I know don't compile that in, and in
>>> fact that is the only reason that i compile USB serial support in
>>> instead of making it a module), and an AT compatible keyboard with any
>>> console option.
>>
>> What about with a USB debugging device (CONFIG_EARLY_PRINTK_DBGP)?
>> That's how debugging over USB is _supposed_ to be done.
> Yes, except those are really expensive, and on some it's pretty easy if
> you don't know what you are doing to really screw things up.

All you need is a Computer with an UDC. Linux has a debugport gadget.

-- 
Thanks,
//richard
