Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3ALKMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 05:12:13 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:51113 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3ALKML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 05:12:11 -0500
X-Greylist: delayed 1387 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jan 2013 05:12:11 EST
Message-ID: <50F12A65.90408@gmail.com>
Date: Sat, 12 Jan 2013 17:18:29 +0800
From: Lan Tianyu <lantianyu1986@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Firefox/17.0 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alex Riesen <raa.lkml@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
References: <CALxABCYMC71rvWeoZ_cW+WHbXRibShuRh1U5A+0WEB-nt2uxHw@mail.gmail.com> <CALxABCau65Zm6qWQCgH+2_4SkojxFPbwwGwytCsiWyyq8bwnRw@mail.gmail.com>
In-Reply-To: <CALxABCau65Zm6qWQCgH+2_4SkojxFPbwwGwytCsiWyyq8bwnRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年1月12日 15:48:59, Alex Riesen wrote:
> On Fri, Jan 11, 2013 at 10:04 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
>> Hi,
>>
>> the USB stick (an Cruzer Titanium 2GB) was not recognized at any of
>> the USB ports of this system (an System76 lemu4 laptop, XHCI device)
>> after it was removed. If I attempt to insert it again in any of the
>> ports (one of the two USB3, or the USB2) the led on the stick lights
>> up shortly and if off again. There is no media detection messages in
>> the dmesg output, only that from the first time:
>>
>>  usb 1-1.2: new high-speed USB device number 3 using ehci-pci
>>  usb 1-1.2: New USB device found, idVendor=0781, idProduct=5408
>>  usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>>  usb 1-1.2: Product: U3 Titanium
>>  usb 1-1.2: Manufacturer: SanDisk Corporation
>>  usb 1-1.2: SerialNumber: 0000187A3A60F1E9
>>  scsi6 : usb-storage 1-1.2:1.0
>>  io scheduler deadline registered (default)
>>  usb 1-1.2: USB disconnect, device number 3
>>
>> The kernel is v3.8-rc3. I never had this problem in 3.7. I could almost
>> reproduce the problem later in a simplified setup (init=/bin/bash) on
>> USB3 ports by inserting and removing the stick quickly. Almost - because
>> the USB3 ports recovered after some time, while the USB2 port never
>> experienced the problem.
>
> One more detail: I usually use the "noop" elevator. That time it was
> the "deadline". And I just reproduced it easily with "deadline".
Can you provide the output of dmesg with CONFIG_USB_DEBUG? This will
be helpful.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Best regards
Tianyu Lan
