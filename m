Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaAUSr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:47:28 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:39170 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbaAUSr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:47:26 -0500
Message-ID: <52DEC0BA.1060007@gmail.com>
Date: Tue, 21 Jan 2014 19:47:22 +0100
From: Branimir Maksimovic <branimir.maksimovic@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: latest git usb3.0 ports not working
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asus maximus v gene motherboard,
this is from dmesg:

[   75.576160] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
[   88.991634] xhci_hcd 0000:03:00.0: Stopped the command ring failed, 
maybe the host is dead
[   88.991748] xhci_hcd 0000:03:00.0: Abort command ring failed
[   88.991845] xhci_hcd 0000:03:00.0: HC died; cleaning up
[   93.985489] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
[   93.985494] xhci_hcd 0000:03:00.0: Abort the command ring, but the 
xHCI is dead.
[   98.982586] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
[   98.982591] xhci_hcd 0000:03:00.0: Abort the command ring, but the 
xHCI is dead.
[  103.979696] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
[  103.979702] xhci_hcd 0000:03:00.0: Abort the command ring, but the 
xHCI is dead.

