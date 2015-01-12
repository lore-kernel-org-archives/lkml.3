Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbbALUNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:13:24 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:35151 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbALUNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:13:22 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2015 15:13:22 EST
Message-ID: <54B429B6.6070809@candelatech.com>
Date: Mon, 12 Jan 2015 12:08:22 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.19.0-rc4+ fails to compile, missing 'usr/missing-syscalls'
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Any idea what is wrong?

-rc3 compiled ok, then I rebased just now, and get this:


cd /mnt/sda/home/greearb/git/linux-3.17.dev.y/drivers/net/wireless/ath/ath10k/
cd ~/kernel/2.6/linux-3.19.x64/; make -j8 bzImage modules
  CHK     include/config/kernel.release
  GEN     ./Makefile
  CHK     include/generated/uapi/linux/version.h
  Using /mnt/sda/home/greearb/git/linux-3.19.dev.y as source for kernel
  CHK     include/generated/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    /mnt/sda/home/greearb/git/linux-3.19.dev.y/scripts/checksyscalls.sh
make[3]: *** No rule to make target `usr/missing-syscalls', needed by `__build'.  Stop.
make[3]: *** Waiting for unfinished jobs....
  CC      kernel/bounds.s
  CHK     include/generated/compile.h
  CC      init/main.o
  CC      init/do_mounts.o
  CC      init/do_mounts_rd.o
/mnt/sda/home/greearb/git/linux-3.19.dev.y/kernel/Makefile:132: *** No X.509 certificates found ***
  CC      init/do_mounts_initrd.o
  AS      arch/x86/ia32/ia32entry.o
make[2]: *** [usr] Error 2
make[2]: *** Waiting for unfinished jobs....
  CC      arch/x86/ia32/sys_ia32.o

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

