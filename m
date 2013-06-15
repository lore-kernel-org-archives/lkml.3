Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3FOPeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 11:34:19 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:58737 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3FOPeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 11:34:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAN+qd7B5YTFw2m5f7wJY1YxAvSQ3imU4nsV=B1JFUQCEWmfsww@mail.gmail.com>
References: <CAN+qd7B5YTFw2m5f7wJY1YxAvSQ3imU4nsV=B1JFUQCEWmfsww@mail.gmail.com>
Date: Sat, 15 Jun 2013 17:34:16 +0200
Message-ID: <CAN+qd7B+=wbxBKV=JrQa3WcCH16fKLJxnj4dywVyGdxE_L0fOA@mail.gmail.com>
Subject: Fwd: bug report about acpiphp
From: diego fanesi <diego.fanesi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to report a bug about the module acpiphp. I don't know if
this is the right place, if it isn't please tell me where I should
write and I will do it.

description: docking station hotplug working on 3.5.0 kernel but not
in previous and next kernel releases
hardware: sony vaio serie z SVZ1311C5E + Docking station VGP-PRZ20A
distro: Ubuntu precise, kernels compiled from the source in kernel.org

The problem is about connecting the docking station after the boot.
with kernel 3.5.0:
when I connect the docking station I can see the following log lines (dmesg):
[ 2442.046921] acpiphp: Slot [1-1] registered
[ 2442.046945] acpiphp: Slot [2] registered
[ 2442.046968] acpiphp: Slot [3] registered
[ 2442.047056] acpiphp: Slot [1-2] registered
[ 2442.047066] acpiphp_glue: sibling found, but _SUN doesn't match!
[ 2442.047169] acpiphp: Slot [1-3] registered
[ 2442.047229] acpiphp: Slot [1-4] registered
[ 2442.047300] acpiphp: Slot [1-5] registered

after that all the devices are available in the system. I can use the
external network, the bluray device, and the usb ports available in
the docking station.
if I unload the acpiphp module the hotplug doesn't work, meaning no
log lines and devices not usable.

with any other kernel (I tried also with 3.10rc5):
when I connect the docking station I cannot see the log lines
specified above, and the devices are not available. I tried with and
without acpiphp loaded.

I didn't tried with other 3.5 kernel versions. I tried with 3.7 and
3.8 and it is not working

If I connect the docking station before the boot with a non 3.5.0
kernel and I unplug it I can continue to see the devices available but
of course not working.


Thank you for your support
