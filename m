Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaFANFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:05:10 -0400
Received: from pindarots.xs4all.nl ([82.161.210.87]:43807 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaFANFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:05:08 -0400
Message-ID: <538B2502.5070707@xs4all.nl>
Date: Sun, 01 Jun 2014 15:05:06 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 3.14.1 network issue with rtl81xx chip
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On two boxes with rtl network chip I see connections going down.
An ifdown eth0;ifup eth0 fixes this.

3.14.1 has the issue.
How can I fix this more elegantly?

Below is info from both boxes from lspci and dmesg:

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 03)

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06


eth0: RTL8168d/8111d at 0xffffc9000060c000, x, XID 081000c0 IRQ 41

eth0: RTL8168evl/8111evl at 0xffffc9000001c000, x, XID 0c900800 IRQ 51


Udo
