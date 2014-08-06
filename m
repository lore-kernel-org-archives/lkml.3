Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaHFDgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 23:36:40 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:51186 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaHFDgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 23:36:39 -0400
MIME-Version: 1.0
From: Leith Bade <leith@leithalweapon.geek.nz>
Date: Wed, 6 Aug 2014 13:36:18 +1000
Message-ID: <CAPDEroWq4+AA4wMroPoShEkBYwB_r5=mi8z6naXzoK4TNjXKBA@mail.gmail.com>
Subject: USB device descriptor read error with Eaton 5E UPS
To: linux-kernel@vger.kernel.org
Cc: Leith Bade <leith@leithalweapon.geek.nz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently purchased a new Easton 5E UPS. I plugged the USB cable into
my computer so I could use the NUT UPS tools. However every so often
NUT fails to connect to the device after a boot.

Looking at dmesg I see errors like this:
[    3.277075] usb 1-9: new low-speed USB device number 6 using xhci_hcd
[    3.302091] usb 1-9: device descriptor read/8, error -32
[    3.430241] usb 1-9: device descriptor read/8, error -32
[    3.653526] usb 1-9: new low-speed USB device number 7 using xhci_hcd
[    3.678473] usb 1-9: device descriptor read/8, error -32
[    3.824288] usb 1-9: device descriptor read/8, error -32
[    4.045977] usb 1-9: new low-speed USB device number 8 using xhci_hcd
[    4.071018] usb 1-9: device descriptor read/8, error -32
[    4.199046] usb 1-9: device descriptor read/8, error -32
[    4.422439] usb 1-9: new low-speed USB device number 9 using xhci_hcd
[    4.451464] usb 1-9: device descriptor read/8, error -32
[    4.579618] usb 1-9: device descriptor read/8, error -32

I have tried to plug it into every USB port (including the USB 3.0
ones) and I still get these errors. I discovered that power cycling
the UPS will fix it for a while, and also unplugging and replugging
the USB cable will also fix it sometimes.

I have observed the problem on both an Asus P9D-I motherboard with the
Intel C222 chipset and on the Asus H87M-E motherboard with the Intel
H87 chipset.

I emailed Eaton support but they don't know what the issue is. They
want me to confirm that it is not Linux or PC issue before I return it
for testing under warranty.

They also said that all warranty testing is performed under Windows only :-(.

How can I be sure that this is a problem with the device and not my
computer before I return it?

I am on Ubuntu Server 14.04 x86-64 bit. The kernel version is:
Linux version 3.13.0-32-generic (buildd@kissel) (gcc version 4.8.2
(Ubuntu 4.8.2-19ubuntu1) ) #57-Ubuntu SMP Tue Jul 15 03:51:08 UTC 2014
(Ubuntu 3.13.0-2.57-generic 3.13.11.4)

P.S. Please reply all so I can get a copy of the reply.

Leith
