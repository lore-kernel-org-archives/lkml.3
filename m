Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3EFHGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:06:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39006 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab3EFHGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:06:54 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: mach-omap2/timer.c: Bug introduced while merging patch - ff931c82
Thread-Topic: mach-omap2/timer.c: Bug introduced while merging patch -
 ff931c82
Thread-Index: Ac5KKDi66bBp82szRKKLkCu0fW3iLw==
Date: Mon, 6 May 2013 07:06:25 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EC7C45D@DBDE04.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Not sure whether this got discussed and fixed already, but Google didn't give me anything :)

The below commit got merged wrongly to Mainline (Changes from timer.c got missed), and 
due to this none of omap boards will boot.


>From ff931c821bab6713a52b768b0cd7ee7e90713b36 Mon Sep 17 00:00:00 2001
From: Rajendra Nayak <rnayak@ti.com>
Date: Thu, 21 Mar 2013 11:04:52 +0000
Subject: ARM: OMAP: clocks: Delay clk inits atleast until slab is initialized


It seems Linux-omap tree has the fix patch for this, and it should get pushed ASAP. 
Below are links for Linus's mainline commit [1], the actual patch submitted to the list [2] and
Commit  present in Linux-omap [3].


[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/arch/arm/mach-omap2/io.c?id=ff931c821bab6713a52b768b0cd7ee7e90713b36
[2] https://patchwork.kernel.org/patch/2300071/
[3] http://git.kernel.org/cgit/linux/kernel/git/tmlind/linux-omap.git/commit/arch/arm/mach-omap2/timer.c?id=ff931c821bab6713a52b768b0cd7ee7e90713b36


Thanks,
Vaibhav

