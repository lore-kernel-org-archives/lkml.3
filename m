Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaGHCek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:34:40 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:44636 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaGHCej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:34:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVgEgDt-mNL_Ee3uOBr2Wj-hEHY1sfDVpH3TiKMKB3B-CQ@mail.gmail.com>
References: <CAPDOMVgEgDt-mNL_Ee3uOBr2Wj-hEHY1sfDVpH3TiKMKB3B-CQ@mail.gmail.com>
Date: Mon, 7 Jul 2014 22:34:38 -0400
Message-ID: <CAPDOMVi=UQoEULy5wrcXuH2Dsk-Nf53uUa0aeMHOnPxU1Bpk7g@mail.gmail.com>
Subject: Fwd: adi-buildroot-devel@lists.sourceforge.net linux-kernel@vger.kernel.org
From: Nick Krause <xerofoify@gmail.com>
To: realmz6 <realmz6@gmail.com>
Cc: adi-buildroot-devel@lists.sourceforge.ne,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Nick Krause <xerofoify@gmail.com>
Date: Mon, Jul 7, 2014 at 10:27 PM
Subject: adi-buildroot-devel@lists.sourceforge.net linux-kernel@vger.kernel.org
To: realmz6@gmail.com


Hey guys ,
Since the errors I get for BF561-ACVILON_defconfig not compiling link
to a failure
in a fileyou guys maintain I am sending you this email.Below my message are the
errors that make this build fail in order to help you create a patch
for  these errors.
Cheer Nick
arch/blackfin/mach-bf561/boards/acvilon.c: In function
‘bfin_plat_nand_dev_ready’:
arch/blackfin/mach-bf561/boards/acvilon.c:283:2: error: implicit
declaration of function ‘gpio_get_value’
[-Werror=implicit-function-declaration]
  return gpio_get_value(BFIN_NAND_PLAT_READY);
  ^
arch/blackfin/mach-bf561/boards/acvilon.c: In function ‘bfin_plat_nand_init’:
arch/blackfin/mach-bf561/boards/acvilon.c:318:2: error: implicit
declaration of function ‘gpio_request’
[-Werror=implicit-function-declaration]
  gpio_request(BFIN_NAND_PLAT_READY, "bfin_nand_plat");
  ^
cc1: some warnings being treated as errors
make[1]: *** [arch/blackfin/mach-bf561/boards/acvilon.o] Error 1
make: *** [arch/blackfin/mach-bf561/boards] Error 2
make: *** Waiting for unfinished jobs....

Hey Steve
Below are the logs for the other the failures related to blackfin
buids. I didn't realize that you maintained most blackfin boards
Cheers Nick

 BlackStamp_defconfig
arch/blackfin/mach-bf533/boards/blackstamp.c:478:2: error: implicit
declaration of function ‘gpio_request’
[-Werror=implicit-function-declaration]
  ret = gpio_request(GPIO_PF0, "enet_cpld");
  ^
arch/blackfin/mach-bf533/boards/blackstamp.c:480:3: error: implicit
declaration of function ‘gpio_direction_output’
[-Werror=implicit-function-declaration]
   gpio_direction_output(GPIO_PF0, 1);
   ^
arch/blackfin/mach-bf533/boards/blackstamp.c:481:3: error: implicit
declaration of function ‘gpio_free’
[-Werror=implicit-function-declaration]
   gpio_free(GPIO_PF0);
   ^
cc1: some warnings being treated as errors
make[1]: *** [arch/blackfin/mach-bf533/boards/blackstamp.o] Error 1
make: *** [arch/blackfin/mach-bf533/boards] Error 2
make: *** Waiting for unfinished jobs....


TCM-BF518_defconfig
UIMAGE  arch/blackfin/boot/uImage.lzma
"mkimage" command not found - U-Boot images will not be built
make[1]: *** [arch/blackfin/boot/uImage.lzma] Error 1
make: *** [uImage] Error 2
