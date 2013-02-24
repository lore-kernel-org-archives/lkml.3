Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab3BXV7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 16:59:15 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:43347 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237Ab3BXV7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 16:59:14 -0500
MIME-Version: 1.0
In-Reply-To: <CABQ2P6FJBSeuGjQbOEuek6QXkRzRbQMHvsApq4g2-0OGykjKZw@mail.gmail.com>
References: <CABQ2P6FJBSeuGjQbOEuek6QXkRzRbQMHvsApq4g2-0OGykjKZw@mail.gmail.com>
Date: Sun, 24 Feb 2013 22:59:13 +0100
Message-ID: <CABQ2P6FVZHWCUogV=xmxv8g-y7RWV_tQqxRMJyxTQK_ixnySjw@mail.gmail.com>
Subject: Fwd: Cpu hotplug causes stutter on AMD platform, how can I disable it?
From: Mario Giammarco <mgiammarco@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have an AMD Athlon(tm) II X4 635 Processor
on an asus M4A89TD PRO/USB3   motherboard with AMD 890FX chipset.
When I play videos on nvidia card (even on open source driver) the
video stutters and I can
see in syslog:

Feb 24 00:30:50 virtual1 kernel: [  719.834878] CPU 1 is now offline
Feb 24 00:30:50 virtual1 kernel: [  719.842450] CPU 2 is now offline
Feb 24 00:30:50 virtual1 kernel: [  719.852534] CPU 3 is now offline
Feb 24 00:30:50 virtual1 kernel: [  719.852538] SMP alternatives:
switching to UP code
Feb 24 00:30:51 virtual1 /usr/sbin/irqbalance: WARNING, didn't collect
load info for all cpus, balancing is broken
Feb 24 00:30:52 virtual1 kernel: [  722.294565] SMP alternatives:
switching to SMP code
Feb 24 00:30:52 virtual1 kernel: [  722.334866] Booting Node 0
Processor 1 APIC 0x1
Feb 24 00:30:52 virtual1 kernel: [  722.346033] LVT offset 1 assigned
for vector 0x400
Feb 24 00:30:52 virtual1 kernel: [  722.361174] Switch to broadcast mode on CPU1
Feb 24 00:30:52 virtual1 kernel: [  722.378717] microcode: CPU1: new
patch_level=0x010000db
Feb 24 00:30:52 virtual1 kernel: [  722.398515] Booting Node 0
Processor 2 APIC 0x2
Feb 24 00:30:52 virtual1 kernel: [  722.413375] Switch to broadcast mode on CPU2
Feb 24 00:30:52 virtual1 kernel: [  722.420603] microcode: CPU2: new
patch_level=0x010000db
Feb 24 00:30:52 virtual1 kernel: [  722.428782] Booting Node 0
Processor 3 APIC 0x3
Feb 24 00:30:52 virtual1 kernel: [  722.446283] Switch to broadcast mode on CPU3
Feb 24 00:30:52 virtual1 kernel: [  722.448615] microcode: CPU3: new
patch_level=0x010000db


I have searched on internet and I see that is a problem common to
several AMD platforms.
Even in Microsoft Windows several people have the same problem and
they solved it disabling cool&quiet on bios. It seems that some amd
cpus on power saving cut off also HT bus blocking data from pcie bus
(!?!)
I have tried too and infact disabling cool&quiet improves a lot the problem.
But I would like to find a better solution, can I disable cpu hotplug?
Have you heard of this bug before?
Please CC me because I am not on kernel mailing list.

Thanks in advance for any help,
Mario
