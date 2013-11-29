Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab3K2JFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:05:42 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43695 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3K2JFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:05:33 -0500
MIME-Version: 1.0
X-Originating-IP: [121.6.203.106]
Date: Fri, 29 Nov 2013 17:05:31 +0800
Message-ID: <CAMVG2svSYPDEhs2vUMDi0jZ8vR9P9O5MmSnsd_ziDGcCe8aURg@mail.gmail.com>
Subject: Re: [PATCH 00/12] Thunderbolt hotplug support for Apple hardware
 (testers needed)
From: Daniel J Blueman <daniel@quora.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 November 2013 09:40:02 UTC+8, Andreas Noever  wrote:
> Thunderbolt hotplug is supposed to be implemented by the firmware. But Apple's
> firmeware only initializes devices during boot and ignores hotplugged devices.
> This patch series adds a driver for the Intel Cactus Ridge Thunderbolt
> controller. The driver supports hotplug operations of simple (one PCI device,
> no chaining) thunderbolt devices.
[...]
> (1) and (2) should be solveable given some time. I also have a pretty good idea
> on how chaining should work. The main problem is that I have yet to see any
> Thunderbolt device besides the Apple ethernet adapter. If someone with a
> MacBook and access to more complicated TB hardware is willing to run some
> tests: Please contact me.
>
> I will try to debug (4) further and write a seperate bug report for the issue.

Superb work! I have a Buffalo MiniStation Thunderbolt [1] and the
Apple ethernet adapter, so will give this a spin over the weekend on
my mid-2012 MacBook Pro retina with the noted constraints.

Thanks,
  Daniel

[1] http://www.buffalo-technology.com/en/products/storage-devices/portable-storage/ministationtm/hd-patu3s-ministation-thunderbolt-portable-ssd/
-- 
Daniel J Blueman
