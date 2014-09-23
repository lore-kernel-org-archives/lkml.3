Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaIWULU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:11:20 -0400
Received: from mout.gmx.net ([212.227.15.19]:60733 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbaIWULS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:11:18 -0400
Message-ID: <5421D3E3.6080805@gmx.de>
Date: Tue, 23 Sep 2014 22:11:15 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
Subject: serial console broken in v3.17-rc6 ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Vwg5n3tnANLUPHtRDspjMpf5BREM7f3ORnc02uWalevb678yNta
 oGU9cBtI3RtHYd5P5ARaKuTssfebnAlOlf5rltiPMqw3/qXsXojzbT8xVcrnlQT527GJcEB
 Lg+SX0Yl4dZVCESuZpFYyxMOnml2rB7eO4S8dMsvLplDZxmoKL4ESvLpXl2Q+5oBBh26NpZ
 1iD/xJIuimSTi0qcLISNQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the release cycle of v3.17 I've seen sometimes a broken serial console output
on the parisc platform. Interestingly all kernel messages printed by the kernel via printk() show
up correctly, but output from userspace (e.g. by the init process during boot) show
up as random bytes.
Since the printk() output is correct the serial port itself and setup is probably correct.
Is parisc the only arch which has this problem, or are other architectures affected as well?
Maybe someone has an idea what could be wrong?
I did not try to bisect it yet.

Thanks,
Helge

Here is a sample output during bootup:

<lots of standard kernel printk output>...
usb 1-2: Manufacturer: SILITEK
rs
      og
  ]f"
s l
random: nonblocking pool is initialized
net eth0: Setting full-duplex based on MII#1 link partner capability of 45e1
tpdsystemd-udevd[744]: starting version 215
.
  eg..
      vp..
          ..Adding 1350652k swap on /dev/sdb6.  Priority:-1 extents:1 across:1350652k
.
  EXT4-fs (sdb5): re-mounted. Opts: (null)
