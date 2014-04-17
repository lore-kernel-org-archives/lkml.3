Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaDQLfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:35:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:42655 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaDQLfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:35:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: shrikant <shrikant.khandare@tudip.com>
Subject: USB 2.0 device is not working in USB 3.0 ports
Date: Thu, 17 Apr 2014 11:29:34 +0000 (UTC)
Message-ID: <loom.20140417T132728-844@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 182.70.21.244 (Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.116 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Ubuntu 12.04 system. To that system I have one USB 3.0 port. In this 
port I am trying use my USB 2.0 device. But every time when I plugged that 
USB 2.0 device into that USB 3.0 port,system gets hanged though I tired to 
shutdown but it won't allow me.

But same type of device I used for USB 2.0 it works fine.

So I have a question as " How can allow USB 3.0 port to use USB 2.0 device or 
did is there any way for converting USB 3.0 port to USB 2.0 port like drivers 
or something".

Here is my lsub command output

Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 003 Device 002: ID 046d:0823 Logitech, Inc. 
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 002 Device 003: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Bus 002 Device 009: ID 046d:0823 Logitech, Inc. 
Bus 002 Device 008: ID 5555:1110 Epiphan Systems Inc. VGA2USB
Bus 002 Device 006: ID 0d8c:0008 C-Media Electronics, Inc. 
Bus 002 Device 007: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth 
Dongle (HCI mode)

and for dmesg command output you can refer this http://pastebin.com/ZvM0kGk2
Suggestions can also appreciating. Thanks in advance.

