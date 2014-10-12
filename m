Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaJLOwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 10:52:00 -0400
Received: from pindarots.xs4all.nl ([82.161.210.87]:37804 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJLOv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 10:51:57 -0400
X-Greylist: delayed 3238 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2014 10:51:57 EDT
Message-ID: <543A88E4.4060707@xs4all.nl>
Date: Sun, 12 Oct 2014 15:57:56 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: CRASH during boot 3.16.3+
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

3.16.2 boots and works fine.
Kernels 3.16.3 and newer crash very early during boot. (did not yet try
3.17)

The problem:
During the first few seconds of bootup the kernel gets into some sort of
loop and rapidly prints loads of register-like things and then a load of
rubbish.
I did `make clean` and then a rebuild etc but this did not help.

How can I capture the logging to find the point where things go wrong?
How can I find out what is wrong?
How can this problem be fixed?

Please post your insights.

Kind regards,
Udo

Base Board Information
        Manufacturer: Gigabyte Technology Co., Ltd.
        Product Name: F2A85X-UP4

# lspci
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Root Complex
00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Family 15h (Models
10h-1fh) I/O Memory Management Unit
00:01.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] Trinity [Radeon HD 7660D]
00:01.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Trinity
HDMI Audio Controller
00:04.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Root Port
00:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Root Port
00:10.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI
Controller (rev 03)
00:10.1 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI
Controller (rev 03)
00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA
Controller [AHCI mode] (rev 40)
00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI
Controller (rev 11)
00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI
Controller (rev 11)
00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI
Controller (rev 11)
00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI
Controller (rev 11)
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller
(rev 14)
00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD] FCH Azalia
Controller (rev 01)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge
(rev 11)
00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD] FCH PCI Bridge
(rev 40)
00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI
Controller (rev 11)
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 0
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 1
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 2
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 3
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 4
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 5
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
02:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host
Controller (rev 01)
03:06.0 Serial controller: MosChip Semiconductor Technology Ltd. PCI
9835 Multi-I/O Controller (rev 01)

