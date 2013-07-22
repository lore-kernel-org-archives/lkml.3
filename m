Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3GVM63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:58:29 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:41700 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3GVM61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:58:27 -0400
MIME-Version: 1.0
Date: Mon, 22 Jul 2013 14:58:25 +0200
Message-ID: <CAO4LoOyW39zCnGq_fnQ5LK9sXD8s3x9LdYvvRMZ=AwfoyaOHqw@mail.gmail.com>
Subject: Unsupported DisplayLink (udl or udlfb module)
From: Paolo Bolzoni <paolo.bolzoni.brown@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel list,
I bought a DVI to VGA adapter[0] hoping to make it work with the
modules udl or udlfb. The program lsusb does recognize it as a
DisplayLink:

//// lsmod output:
Bus 002 Device 004: ID 17e9:4300 DisplayLink

But, it does not matter what of the two modules I have loaded it
seems the kernel does not recognize it

# modprobe udl
//// plugging
# dmesg|tail -3
[ 5500.731973] usb 2-1: new SuperSpeed USB device number 5 using xhci_hcd
[ 5500.747190] usbip-host 2-1:1.0: 2-1 is not in match_busid table... skip!
[ 5500.747760] usbip-host 2-1:1.1: 2-1 is not in match_busid table... skip!
//// unplugging
# rmmod udl
# modprobe udlfb
//// plugging
# dmesg|tail -4
[ 5544.168599] usb 2-1: USB disconnect, device number 5
[ 5560.144758] usb 2-1: new SuperSpeed USB device number 6 using xhci_hcd
[ 5560.160033] usbip-host 2-1:1.0: 2-1 is not in match_busid table... skip!
[ 5560.160585] usbip-host 2-1:1.1: 2-1 is not in match_busid table... skip!

I tried seeking on the Internet, but I could not find anything about
this 17e9:4300 model. So I ask, it will be supported? It is already
supported somewhat? Can I help? I have no experience in kernel
programming; but asking is legit I guess.

Please if you answer put my address paolo.bolzoni.brown@gmail.com in
CC as I did not register to the mailing list scared by the huge volume.

Yours sincerely,
Paolo Bolzoni


[0] http://www.amazon.co.uk/exec/obidos/ASIN/B0086359SG/ref=ox_ya_os_product
