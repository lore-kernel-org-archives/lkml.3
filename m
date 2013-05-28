Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825Ab3E1JmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:42:18 -0400
Received: from mail-ie0-f196.google.com ([209.85.223.196]:65005 "EHLO
	mail-ie0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab3E1JmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:42:16 -0400
MIME-Version: 1.0
Date: Tue, 28 May 2013 15:12:16 +0530
Message-ID: <CAAWiN8oSfH9fZVvnMtfehaY+D-9qhtqu4fwedVOv5Q-uB0WNYw@mail.gmail.com>
Subject: Why Linux OS Desktop is not popular?
From: Amit C <amit.linux.os.desktop@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Linux OS Desktop has not become very popular because of the following reasons:

1. It is not because its GUI is not good.
2. It is because if I buy a new gadget/device/hardware, I am not sure
whether it will work with Linux Desktop.
3. The reason for number 2 is that the vendor introducing
gadget/device/hardware does not write a device driver for Linux.
4. The reason for number 3 is that developing new device driver on
linux is hard.
5. The way to solve number 4 is to move to data oriented device driver
development where the framework for driver is already available for
all kinds of devices (PCI, USB, Firewire, etc.) and the only thing a
device driver developer has to do is to collect io/virtual addresses
from the vendor/manual and feed into a table (structure of structures,
etc.) and the framework will pick up this data and configure the new
gadget/device/hardware instantly.

I do not want to pay for Microsoft OS but can Linux community give me
a usable Linux Desktop. I have both Windows and Linux on my laptop and
I use Microsoft just to connect to Internet because the USB dongle
that I use for connecting to Internet does not work on Linux. I am in
India and here USB dongles connecting to Internet are very popular
because you can use them anywhere.

Regards,
Amit
