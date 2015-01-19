Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbbASO5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:57:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:3004 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbbASO5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:57:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,427,1418112000"; 
   d="scan'208";a="672254523"
Message-ID: <54BD1B70.5090305@linux.intel.com>
Date: Mon, 19 Jan 2015 16:57:52 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>,
        Robert Hancock <hancockrwd@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-usb <linux-usb@vger.kernel.org>
Subject: Re: 3.18 regression: Error while assigning device slot ID, USB3 devices
 not detected
References: <54BB4DD2.1070602@gmail.com>	<20150118062531.GA8968@kroah.com>	<CA+5PVA65KS+_ujc2yQ=zOnFPMZz__2K8Vm+wV5YJKkuEuHwn3Q@mail.gmail.com>	<20150119133346.GA4490@kroah.com> <CA+5PVA5bTAh+qi7VjUE8XUx-XvgmzoV0RvrqTkBBR_kf+D-CKQ@mail.gmail.com>
In-Reply-To: <CA+5PVA5bTAh+qi7VjUE8XUx-XvgmzoV0RvrqTkBBR_kf+D-CKQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.01.2015 15:47, Josh Boyer wrote:
> On Mon, Jan 19, 2015 at 8:33 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Mon, Jan 19, 2015 at 08:28:19AM -0500, Josh Boyer wrote:
>>> On Sun, Jan 18, 2015 at 1:25 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>> On Sun, Jan 18, 2015 at 12:08:18AM -0600, Robert Hancock wrote:
>>>>> I've got an Intel Haswell-based system with a Gigabyte Z87X-D3H motherboard
>>>>> under Fedora 21. After updating to the 3.18.2-200 Fedora kernel, I noticed
>>>>> some errors in dmesg and at least some of my USB3 ports don't recognize any
>>>>> USB3 devices plugged into them:
>>>>>
>>>>> [    0.560838] xhci_hcd 0000:00:14.0: Error while assigning device slot ID
>>>>> [    0.560912] xhci_hcd 0000:00:14.0: Max number of devices this xHCI host
>>>>> supports is 32.
>>>>> [    0.560990] usb usb2-port2: couldn't allocate usb_device
>>>>> [    0.561098] xhci_hcd 0000:00:14.0: Error while assigning device slot ID
>>>>> [    0.561163] xhci_hcd 0000:00:14.0: Max number of devices this xHCI host
>>>>> supports is 32.
>>>>> [    0.561239] usb usb2-port5: couldn't allocate usb_device
>>>>> [    0.561344] xhci_hcd 0000:00:14.0: Error while assigning device slot ID
>>>>> [    0.561409] xhci_hcd 0000:00:14.0: Max number of devices this xHCI host
>>>>> supports is 32.
>>>>> [    0.561484] usb usb2-port6: couldn't allocate usb_device
>>>>>
>>>>> This worked fine under 3.17. Is this a known problem?
>>>>
>>>> Yes it is, should be fixed in Linus's tree now and will be backported to
>>>> the latest 3.18-stable tree in a week or so.
>>>
>>> Do you happen to know the commit id?
>>
>> f161ead70fa6a62e432dff6e9dab8e3cfbeabea6
> 
> Thanks!
> 

Tell me if this fixed the issue.
I got this gut feeling this might be something else.
It should have failed in 3.17 as well

-Mathias
