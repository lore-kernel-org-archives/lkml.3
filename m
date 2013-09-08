Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3IHGEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 02:04:12 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:49510 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab3IHGEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 02:04:11 -0400
MIME-Version: 1.0
Date: Sun, 8 Sep 2013 11:34:10 +0530
Message-ID: <CABYxbz7m4GdHFNY3fP1Cpv3a_dNTSozdd7dX9yLG6vQ3zZxu9A@mail.gmail.com>
Subject: Build error in torvalds kernel 3.11 for omap2plus
From: Anil Kumar <anilk4.v@gmail.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Benoit Cousson <b-cousson@ti.com>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am getting below build error in torvalds kernel 3.11 for omap2plus.


scripts/kconfig/conf --silentoldconfig Kconfig
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: `include/generated/mach-types.h' is up to date.
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  AS      arch/arm/mm/cache-v7.o
arch/arm/mm/cache-v7.S: Assembler messages:
arch/arm/mm/cache-v7.S:285: Error: garbage following instruction -- `dsb ishst'
arch/arm/mm/cache-v7.S:297: Error: garbage following instruction -- `dsb ishst'
make[1]: *** [arch/arm/mm/cache-v7.o] Error 1
make: *** [arch/arm/mm] Error 2

Thanks
Anil
