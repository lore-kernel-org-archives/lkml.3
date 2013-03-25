Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab3CYIcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:32:00 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:41648 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab3CYIb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <1360663374-30951-2-git-send-email-s.hauer@pengutronix.de>
References: <1360663374-30951-1-git-send-email-s.hauer@pengutronix.de> <1360663374-30951-2-git-send-email-s.hauer@pengutronix.de>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 25 Mar 2013 09:31:35 +0100
Message-ID: <CAH9NwWdOCo642KqUXk1y5hbwdtW5RYgQnQfZFUEe4FOJzSiByQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86: Add basic support for the Congatec CGEB BIOS interface
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-i2c@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha


> +struct cgeb_pdata {
> +       struct cgeb_board_data          *board;
> +       int unit;
> +};
> +
> +#endif /* __CONGATEC_CGEB_H */
> diff --git a/arch/x86/platform/Makefile b/arch/x86/platform/Makefile
> index 8d87439..9de1789 100644
> --- a/arch/x86/platform/Makefile
> +++ b/arch/x86/platform/Makefile
> @@ -1,5 +1,6 @@
>  # Platform specific code goes here
>  obj-y  += ce4100/
> +obj-y  += congatec/
>  obj-y  += efi/
>  obj-y  += geode/
>  obj-y  += iris/


Fails to build


christian@chgm-pc:~/kernel/linux_mainline$ make
make[1]: Nothing to be done for `all'.
make[1]: Nothing to be done for `relocs'.
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      scripts/mod/devicetable-offsets.s
  GEN     scripts/mod/devicetable-offsets.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTLD  scripts/mod/modpost
  CHK     include/generated/compile.h
scripts/Makefile.build:44:
/home/christian/kernel/linux_mainline/arch/x86/platform/congatec/Makefile:
No such file or directory
make[3]: *** No rule to make target
`/home/christian/kernel/linux_mainline/arch/x86/platform/congatec/Makefile'.
 Stop.
make[2]: *** [arch/x86/platform/congatec] Error 2
make[1]: *** [arch/x86/platform] Error 2
make: *** [arch/x86] Error 2


--
Christian Gmeiner, MSc
