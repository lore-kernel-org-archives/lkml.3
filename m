Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbbARGIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 01:08:23 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57159 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbbARGIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 01:08:21 -0500
Message-ID: <54BB4DD2.1070602@gmail.com>
Date: Sun, 18 Jan 2015 00:08:18 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-usb <linux-usb@vger.kernel.org>
Subject: 3.18 regression: Error while assigning device slot ID, USB3 devices
 not detected
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got an Intel Haswell-based system with a Gigabyte Z87X-D3H 
motherboard under Fedora 21. After updating to the 3.18.2-200 Fedora 
kernel, I noticed some errors in dmesg and at least some of my USB3 
ports don't recognize any USB3 devices plugged into them:

[    0.560838] xhci_hcd 0000:00:14.0: Error while assigning device slot ID
[    0.560912] xhci_hcd 0000:00:14.0: Max number of devices this xHCI 
host supports is 32.
[    0.560990] usb usb2-port2: couldn't allocate usb_device
[    0.561098] xhci_hcd 0000:00:14.0: Error while assigning device slot ID
[    0.561163] xhci_hcd 0000:00:14.0: Max number of devices this xHCI 
host supports is 32.
[    0.561239] usb usb2-port5: couldn't allocate usb_device
[    0.561344] xhci_hcd 0000:00:14.0: Error while assigning device slot ID
[    0.561409] xhci_hcd 0000:00:14.0: Max number of devices this xHCI 
host supports is 32.
[    0.561484] usb usb2-port6: couldn't allocate usb_device

This worked fine under 3.17. Is this a known problem?
