Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab3BYV5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 16:57:44 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:47908 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832Ab3BYV5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 16:57:42 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
 <Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 25 Feb 2013 14:57:20 -0700
Message-ID: <CAErSpo7NZoOQZyW76HEoOTVgdqL2CgbVScAeF6HGLAVaNCq0=w@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 9:22 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 12 Feb 2013, Bjorn Helgaas wrote:
>
>> [+cc linux-pci, Rafael, Alan]
>>
>> [https://bugzilla.kernel.org/show_bug.cgi?id=53551]
>>
>> On Tue, Feb 12, 2013 at 1:13 PM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
>> > Feb 13, 2013 01:32:53 AM, Linus Torvalds wrote:
>> > On Tue, Feb 12, 2013 at 10:29 AM, Artem S. Tashkinov wrote:
>> >>> Feb 12, 2013 11:30:20 PM, Linus Torvalds wrote:
>> >>>>
>> >>>>A few things to try to pinpoint:
>> >>>>
>> >>>> (a) Is it *only* write performance that suffers, or is it other
>> >>>>performance too? Networking (DMA? Perhaps only writing *to* the
>> >>>>network?)? CPU?
>> >>>
>> >>> I  've tested hdpard -tT --direct and the output on boot and after suspend
>> >>> is quite similar.
>> >>>
>> >>> I  've also checked my network read/write speed, and it  's the same
>> >>> ~ 100MBit/sec (I have no 1Gbit computers on my network
>> >>> unfortunately).
>> >>
>> >>Ok. So it really sounds like just USB and HD writes. Which is quite
>> >>odd, since they have basically nothing in common I can think of
>> >>(except the obvious block layer issues).
>
> There's a slight chance that we might get some ideas by comparing
> usbmon traces showing disk activity before and after the
> problem-causing suspend.

Where are we at with this, Artem?  I assume it's still a problem.
