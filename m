Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab3BRWnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 17:43:47 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45067 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab3BRWnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 17:43:45 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1302181736430.6790-100000@netrider.rowland.org>
References: <CAP9ODKp3BNArKoWOVQ6D1-ky=fkir84SSp3V3WSdpnPwnTfdoA@mail.gmail.com>
	<Pine.LNX.4.44L0.1302181736430.6790-100000@netrider.rowland.org>
Date: Mon, 18 Feb 2013 19:43:44 -0300
X-Google-Sender-Auth: 8gZgk3C1lHOE0veb7RDJB5xeR-g
Message-ID: <CAP9ODKqFSL6zqy7q3ouJ3sWfen_4NS7_O=mR4GvrnN2Pd1Wd0g@mail.gmail.com>
Subject: Re: Linux 3.8 broken for MacBookAir5,1
From: Otavio Salvador <otavio@ossystems.com.br>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 7:38 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 18 Feb 2013, Otavio Salvador wrote:
>
>> >> I thought the ehci-pci module would be load for every ehci PCI; What
>> >> do you think?
>> >
>> > The kernel can't guarantee anything about what driver modules are
>> > loaded.  That's up to userspace.  In particular, the initramfs image
>> > must be set up properly (if that is where these modules are loaded
>> > from).
>>
>> But why kernel cannot load it if we have a PCI subsystem? Or do you
>> think my initrd did not put the module on the initramfs image?
>
> That's exactly what I think.  See this message and the corresponding
> thread:
>
>         http://marc.info/?l=linux-usb&m=136074995914335&w=2

Thanks Alan, this was the problem.

Regards,

-- 
Otavio Salvador                             O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854              http://projetos.ossystems.com.br
