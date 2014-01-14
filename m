Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaANEJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:09:52 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3218 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaANEJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:09:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 13 Jan 2014 20:09:45 -0800
Message-ID: <52D4B88E.8090109@nvidia.com>
Date: Mon, 13 Jan 2014 20:09:50 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel-build-reports@lists.linaro.org" 
	<kernel-build-reports@lists.linaro.org>
Subject: Tegra baseline test results for v3.13-rc8
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some basic Tegra test results for Linux v3.13-rc8.
Logs and other details at:

     http://nvt.pwsan.com/pub/linux/testlogs/test_v3.13-rc8/20140112023108/


Test summary
------------

Build: zImage:
     Pass: ( 2/ 2): multi_v7_defconfig, tegra_defconfig

Boot to userspace: multi_v7_defconfig:
     Pass: ( 2/ 2): tegra114-dalmore-headless, tegra30-beaver

Boot to userspace: tegra_defconfig:
     Pass: ( 2/ 2): tegra114-dalmore-headless, tegra30-beaver


vmlinux object size
(delta in bytes from test_v3.13-rc7 (d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc)):
    text     data      bss    total  kernel
     +56        0        0      +56  multi_v7_defconfig
   +1373      -24        0    +1349  tegra_defconfig


Boot-time memory difference
(delta in bytes from test_v3.13-rc7 (d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc))
     avail    rsrvd     high    freed                board              kconfig                  dtb
         .        .        .        . tegra114-dalmore-hea   multi_v7_defconfig     tegra114-dalmore
         .        .        .        . tegra114-dalmore-hea      tegra_defconfig     tegra114-dalmore
         .        .        .        .       tegra30-beaver   multi_v7_defconfig       tegra30-beaver
         .        .        .        .       tegra30-beaver      tegra_defconfig       tegra30-beaver


- Paul
