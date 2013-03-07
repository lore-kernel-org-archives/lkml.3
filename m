Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3CGBMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:12:47 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39750 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3CGBMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:12:46 -0500
Message-ID: <5137E987.7090904@gmail.com>
Date: Thu, 07 Mar 2013 09:12:39 +0800
From: yeyouqun <yeyouqun1981@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Ugrade linux kernel from 3.6.10 to 3.8.2 and boot failed.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, guys:

      I have upgrade my kernel version from 3.6.10 to 3.8.2, but boot
failed. The message reads as below:

     ......
     IMA No TPM chip found, activating TPM-bypas!
     rtc_cmos OO:03: setting systen clock t0 2013-03-06 10:38:39 UTC
     (1362566319)
     Freeing unused kernel memory: 1504k freed
     Write protecting the kernel read-only data.: 1024k
     Freeing unused kernel nenory: 684k freed
     Freeing unused kernel nenory: 1456k freed
     dracut: dracut-dracut-024-
     rpcbind: cannot create socket for udp6
     rpcbind: cannot create socket for tcp6
     mount: unknoun filesys
     udev: starting version 147
     systend-udevd (139): /proc/139/oom_adj is deprecated, please use
     /proc/139/oom_score_adj instead.
     dracut Warning: Could not boot.
     dracut Warning: Could not boot.
     Dropping to debug shell.
     /bin/sh: can't access tty; job control turned off
     dracut:/#

     Any one could help?


     My system:

     Redhat Enterprise Edition Linux 6.2
     VMWare
     udev version : 147
     dracut version : 024
     GCC:

         COLLECT_GCC=gcc
         
COLLECT_LTO_WRAPPER=/usr/local/libexec/gcc/x86_64-redhat-linux/4.6.2/lto-wrapper
         Target: x86_64-redhat-linux
         Configured with: ../configure --enable-bootstrap --enable-shared
         --enable-threads=posix --enable-checking=release
         --with-system-zlib --enable-__cxa_atexit
         --enable-libunwind-exceptions --enable-gnu-unique-object
         --enable-languages=c,c++,objc,obj-c++ --with-gmp=/usr/local
         --with-mpfr=/usr/local --with-mpc=/usr/local
         --with-ppl=/usr/local --with-cloog=/usr/local
         --with-tune=generic --with-arch_32=i686 
--build=x86_64-redhat-linux
         Thread model: posix
         gcc version 4.6.2 (GCC)
