Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaDONwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:52:23 -0400
Received: from pindarots.xs4all.nl ([82.161.210.87]:54783 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaDONwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:52:22 -0400
X-Greylist: delayed 2034 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 09:52:22 EDT
Message-ID: <534D31A0.6020906@xs4all.nl>
Date: Tue, 15 Apr 2014 15:18:24 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 3.13.9: ethernet connectivity issue
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People,

Here's an issue with ethernet connectivity that stops working but is
resurrected with an `ifdown eth0; ifup eth0`.

The board is a Jetway JNC84E-LF with AMD Athlon(tm) II X2 235e Processor.
Network chip: 02:00.0 Ethernet controller: Realtek Semiconductor Co.,
Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 03
is handled by r8169 driver.
After a while (less than 24 hours typical) I discover that this machine
is not reachable anymore and solve it with ifdown/ifup.
I find no related messages in dmesg nor /var/log/messages.
I tried to continuously ping this box but that did not help.

How could I find the cause of this issue that started occurring after
booting into 3.13.9?
Before this kernel it ran 3.12.5 since just before Christmas 2013
without this issue.

Kind regards,
Udo
