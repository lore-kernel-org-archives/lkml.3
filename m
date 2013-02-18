Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3BRWKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 17:10:43 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:58419 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab3BRWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 17:10:41 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1302181707320.6790-100000@netrider.rowland.org>
References: <CAP9ODKrFqj_LTvvx-D5ERxjGcpp4FP6WsvrvkoFBJM-gaPihvw@mail.gmail.com>
	<Pine.LNX.4.44L0.1302181707320.6790-100000@netrider.rowland.org>
Date: Mon, 18 Feb 2013 19:10:41 -0300
X-Google-Sender-Auth: t6IPYanwLl2_fTm5h78UV_eXZ5g
Message-ID: <CAP9ODKp3BNArKoWOVQ6D1-ky=fkir84SSp3V3WSdpnPwnTfdoA@mail.gmail.com>
Subject: Re: Linux 3.8 broken for MacBookAir5,1
From: Otavio Salvador <otavio@ossystems.com.br>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 7:09 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 10 Feb 2013, Otavio Salvador wrote:
>
>> On Sun, Feb 10, 2013 at 12:47 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > On Sun, 10 Feb 2013, Otavio Salvador wrote:
>> >> I do have EHCI and PCI enabled so it should be working. Any clue about
>> >> why it breaks it?
>> >
>> > Perhaps your system is not loading the new ehci-pci kernel module.
>>
>> Yes; it should be the cause as building it built-in makes it work.
>> However it is a regression from my point of view.
>>
>> Those are the controllers I have in my system:
>>
>> 00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
>> Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04)
>> 00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
>> Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04)
>> 00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
>> Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04)
>>
>> I thought the ehci-pci module would be load for every ehci PCI; What
>> do you think?
>
> The kernel can't guarantee anything about what driver modules are
> loaded.  That's up to userspace.  In particular, the initramfs image
> must be set up properly (if that is where these modules are loaded
> from).

But why kernel cannot load it if we have a PCI subsystem? Or do you
think my initrd did not put the module on the initramfs image?

-- 
Otavio Salvador                             O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854              http://projetos.ossystems.com.br
