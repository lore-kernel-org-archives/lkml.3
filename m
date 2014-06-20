Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935007AbaFTQ1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:27:15 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:37731 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934502AbaFTQ1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1406201056270.1160-100000@iolanthe.rowland.org>
References: <CADDKRnBqPVg63sbaWX-w4Log_Sr+DFth5nURY7T=nRh6UxymWg@mail.gmail.com>
	<Pine.LNX.4.44L0.1406201056270.1160-100000@iolanthe.rowland.org>
Date: Fri, 20 Jun 2014 18:27:12 +0200
Message-ID: <CADDKRnAqQ16ng2VqPLnKBy2jVMm4tbm+AfjCUBd2pyX11zCHag@mail.gmail.com>
Subject: Re: [usb resume regression] in 3.16-rc1
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-20 16:57 GMT+02:00 Alan Stern <stern@rowland.harvard.edu>:
> On Fri, 20 Jun 2014, Jörg Otte wrote:
>
>> 2014-06-19 19:35 GMT+02:00 Alan Stern <stern@rowland.harvard.edu>:
>> > On Thu, 19 Jun 2014, Jörg Otte wrote:
>> >
>> >> I don't know how to do this.
>> >
>> > To enable dynamic debugging (as root):
>> >
>> >     echo 'module usbcore =p' >/sys/kernel/debug/dynamic_debug/control
>> >     echo 'module ehci_hcd =p' >/sys/kernel/debug/dynamic_debug/control
>> >
>> > Do this before you carry out the suspend, and post the resulting dmesg
>> > log.
>> >
>> > Alan Stern
>> >
>> here it is.
>
> Now I see the reason for the regression.  There already is a patch to
> fix it:
>
>         http://marc.info/?l=linux-usb&m=140304702623966&w=2
>
> The fix will probably be included in 3.16-rc2 or -rc3.
>
> Alan Stern
>
The patch works for me.

Thanks, Jörg
