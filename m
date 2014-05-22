Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaEVGhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 02:37:42 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:62393 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEVGhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 02:37:41 -0400
MIME-Version: 1.0
Date: Thu, 22 May 2014 12:07:40 +0530
Message-ID: <CAJb+z00bA+wbE+vO09wo=frpVRZiVnXjdo2FJHdd_bsp9Ec83g@mail.gmail.com>
Subject: USB 3.0 - Synopsis DWC Host-AHB - on Linux Kernel 3.10.28
From: krishnamurthy holla <kmholla@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am using Linux kernel 3.10.28 - MIPS processor (BIG Endian)

I see that XHCI fails during xhci_device_alloc() because of
wait_for_completion_interruptible_timeout () when I connect a device.

So, I thought of initializing host controller as BE as my host is BE.
But this time, it failed much earlier, i.e in xhci_handle_event()
itself for the check le32_to_cpu(event->event_cmd.flags) & TRB_CYCLE)
!=  xhci->event_ring->cycle_state)

I would like to know if any of you used Synopsis DWC Host-AHB and got
successful device detection. Also, Please let me know if XHCI needs
special configuration on Big Endian system.

Thanks
