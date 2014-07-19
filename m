Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbaGSCMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 22:12:32 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:39765 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbaGSCMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 22:12:30 -0400
MIME-Version: 1.0
In-Reply-To: <53C9ADDC.7060506@infradead.org>
References: <CAPDOMVjrRS1zSDwQ0KVL6-m774_gAwM8Ov4mehDvUZXjtmVrOA@mail.gmail.com>
	<53C96313.7060608@infradead.org>
	<CAPDOMVhUd+cF8PWmWJOEsuCdDuON5_KpO-pZA-aT4n351FgOWg@mail.gmail.com>
	<53C9ADDC.7060506@infradead.org>
Date: Fri, 18 Jul 2014 22:12:29 -0400
Message-ID: <CAPDOMVj0eDYBrJEq5bEaw+0wNkY2NcxximMS-NTn_6EgyF-X7Q@mail.gmail.com>
Subject: Re: Build Errors when building usb directory
From: Nick Krause <xerofoify@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 7:29 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 07/18/2014 12:59 PM, Nick Krause wrote:
>> On Fri, Jul 18, 2014 at 2:10 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>>> On 07/18/2014 10:45 AM, Nick Krause wrote:
>>>> Hey Greg and others,
>>>> When I built the usb directory today to check a patch I am also
>>>> sending to. I seem to hitting
>>>> a few compiler errors and a lot of warnings.  I am going to attach a
>>>> file of my log of this build.
>>>> Cheers Nick
>>>>
>>>
>>> Hi,
>>>
>>> What command(s) did you use to build the usb directory?
>>>
>>> thanks,
>>> --
>>> ~Randy
>> I used make M=drivers/usb to build it.
>> Cheers Nick
>
>
> I'm not seeing any of these warnings, but I am testing 3.16-rc5.
>
> Nick, are you using a current git tree?  If so, which one?
> You should always specify what kernel it is that you are testing.
>
>
> --
> ~Randy

This is the lastest commit idea on my
tree,f83971912231fe5390d2357442b6c25bb8076d9b.
Cheers Nick
