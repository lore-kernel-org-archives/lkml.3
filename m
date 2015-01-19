Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbbASPky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:40:54 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:63155 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbASPkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:40:53 -0500
MIME-Version: 1.0
In-Reply-To: <54BD1B70.5090305@linux.intel.com>
References: <54BB4DD2.1070602@gmail.com>
	<20150118062531.GA8968@kroah.com>
	<CA+5PVA65KS+_ujc2yQ=zOnFPMZz__2K8Vm+wV5YJKkuEuHwn3Q@mail.gmail.com>
	<20150119133346.GA4490@kroah.com>
	<CA+5PVA5bTAh+qi7VjUE8XUx-XvgmzoV0RvrqTkBBR_kf+D-CKQ@mail.gmail.com>
	<54BD1B70.5090305@linux.intel.com>
Date: Mon, 19 Jan 2015 10:40:52 -0500
X-Google-Sender-Auth: H4gCVFITXIBzzYewutVNVCAOKKo
Message-ID: <CA+5PVA7O__NQfDgLZuHAOn8XvBNODB3g0=FeKRWArb59YKs_7Q@mail.gmail.com>
Subject: Re: 3.18 regression: Error while assigning device slot ID, USB3
 devices not detected
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 9:57 AM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
> On 19.01.2015 15:47, Josh Boyer wrote:
>> On Mon, Jan 19, 2015 at 8:33 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Mon, Jan 19, 2015 at 08:28:19AM -0500, Josh Boyer wrote:
>>>> On Sun, Jan 18, 2015 at 1:25 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>> On Sun, Jan 18, 2015 at 12:08:18AM -0600, Robert Hancock wrote:
>>>>>> I've got an Intel Haswell-based system with a Gigabyte Z87X-D3H motherboard
>>>>>> under Fedora 21. After updating to the 3.18.2-200 Fedora kernel, I noticed
>>>>>> some errors in dmesg and at least some of my USB3 ports don't recognize any
>>>>>> USB3 devices plugged into them:
>>>>>>
>>>>>> [    0.560838] xhci_hcd 0000:00:14.0: Error while assigning device slot ID
>>>>>> [    0.560912] xhci_hcd 0000:00:14.0: Max number of devices this xHCI host
>>>>>> supports is 32.
>>>>>> [    0.560990] usb usb2-port2: couldn't allocate usb_device
>>>>>> [    0.561098] xhci_hcd 0000:00:14.0: Error while assigning device slot ID
>>>>>> [    0.561163] xhci_hcd 0000:00:14.0: Max number of devices this xHCI host
>>>>>> supports is 32.
>>>>>> [    0.561239] usb usb2-port5: couldn't allocate usb_device
>>>>>> [    0.561344] xhci_hcd 0000:00:14.0: Error while assigning device slot ID
>>>>>> [    0.561409] xhci_hcd 0000:00:14.0: Max number of devices this xHCI host
>>>>>> supports is 32.
>>>>>> [    0.561484] usb usb2-port6: couldn't allocate usb_device
>>>>>>
>>>>>> This worked fine under 3.17. Is this a known problem?
>>>>>
>>>>> Yes it is, should be fixed in Linus's tree now and will be backported to
>>>>> the latest 3.18-stable tree in a week or so.
>>>>
>>>> Do you happen to know the commit id?
>>>
>>> f161ead70fa6a62e432dff6e9dab8e3cfbeabea6
>>
>> Thanks!
>>
>
> Tell me if this fixed the issue.
> I got this gut feeling this might be something else.
> It should have failed in 3.17 as well

OK.  We're tracking this in the bug Robert filed here:

https://bugzilla.redhat.com/show_bug.cgi?id=1183289

The patch should be in the next Fedora kernel build, so hopefully we
can get back to you soon.

josh
