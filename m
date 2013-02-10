Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3BJQki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 11:40:38 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:59069 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3BJQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 11:40:36 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1302100946040.29460-100000@netrider.rowland.org>
References: <CAP9ODKr2gomJR6Zrwc41ddhxn3nkFYtTLL-_xhbdRKN=n-A_+w@mail.gmail.com>
	<Pine.LNX.4.44L0.1302100946040.29460-100000@netrider.rowland.org>
Date: Sun, 10 Feb 2013 14:40:33 -0200
X-Google-Sender-Auth: XXrlt8giMWPEU5raQGYGCF7M9X8
Message-ID: <CAP9ODKrFqj_LTvvx-D5ERxjGcpp4FP6WsvrvkoFBJM-gaPihvw@mail.gmail.com>
Subject: Re: Linux 3.8 broken for MacBookAir5,1
From: Otavio Salvador <otavio@ossystems.com.br>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 12:47 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 10 Feb 2013, Otavio Salvador wrote:
>> I do have EHCI and PCI enabled so it should be working. Any clue about
>> why it breaks it?
>
> Perhaps your system is not loading the new ehci-pci kernel module.

Yes; it should be the cause as building it built-in makes it work.
However it is a regression from my point of view.

Those are the controllers I have in my system:

00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04)
00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04)
00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04)

I thought the ehci-pci module would be load for every ehci PCI; What
do you think?

--
Otavio Salvador                             O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854              http://projetos.ossystems.com.br
