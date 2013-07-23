Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3GWIPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:15:45 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:38139 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3GWIPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:15:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAAfyv36tJ3bF-uTTd8yqs-4eCJUV6Pz9Acz3pD-VESwTBrSHOQ@mail.gmail.com>
References: <CAO4LoOyW39zCnGq_fnQ5LK9sXD8s3x9LdYvvRMZ=AwfoyaOHqw@mail.gmail.com>
	<CAAfyv36tJ3bF-uTTd8yqs-4eCJUV6Pz9Acz3pD-VESwTBrSHOQ@mail.gmail.com>
Date: Tue, 23 Jul 2013 10:15:34 +0200
Message-ID: <CAO4LoOydyJrgaAZmc_K2f4avuOfs+5BvQcGpWFZVf8ki8=-y9w@mail.gmail.com>
Subject: Re: Unsupported DisplayLink (udl or udlfb module)
From: Paolo Bolzoni <paolo.bolzoni.brown@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 10:07 PM, Belisko Marek <marek.belisko@gmail.com> wrote:
>> But, it does not matter what of the two modules I have loaded it
>> seems the kernel does not recognize it
> Matching is done by VID = 0x17e9 which seem match but then by
> bInterfaceClass = 0xff, bInterfaceSubClass = 0x00 and bInterfaceProtocol = 0x00.
> Can you please post lsusb -v to check what are other parameters for your device.
Sure thing, I appended the output at the end of the email because it
is a little long.

Please if you answer put my address paolo.bolzoni.brown@gmail.com in
CC as I did not register to the mailing list.

Your sincerely,
Paolo


Here is the lsusb -v output about my DisplayLink:

Bus 003 Device 002: ID 17e9:4300 DisplayLink
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0         9
  idVendor           0x17e9 DisplayLink
  idProduct          0x4300
  bcdDevice            2.36
  iManufacturer           1
  iProduct                2
  iSerial                 3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          103
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              126mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      3
      iInterface              0
      ** UNRECOGNIZED:  0c 5f 01 00 0a 00 04 04 01 00 04 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               5
        bMaxBurst               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass       254 Application Specific Interface
      bInterfaceSubClass      1 Device Firmware Update
      bInterfaceProtocol      1
      iInterface              0

      Device Firmware Upgrade Interface Descriptor:
        bLength                             9
        bDescriptorType                    33
        bmAttributes                        1
          Will Not Detach
          Manifestation Intolerant
          Upload Unsupported
          Download Supported
        wDetachTimeout                    200 milliseconds
        wTransferSize                    1024 bytes
        bcdDFUVersion                   1.01
      ** UNRECOGNIZED:  10 40 06 01 09 01 01 03 45 6c 6c 61 44 6f 63 6b
