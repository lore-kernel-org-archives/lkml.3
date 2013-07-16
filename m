Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3GPJ3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:29:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43969 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3GPJ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:29:20 -0400
MIME-Version: 1.0
In-Reply-To: <51E50D24.8030900@monstr.eu>
References: <alpine.DEB.2.02.1307160950110.8862@ayla.of.borg>
	<51E50D24.8030900@monstr.eu>
Date: Tue, 16 Jul 2013 11:29:19 +0200
X-Google-Sender-Auth: Dpk65wu8P3Wf-_rpeVm_wURacr8
Message-ID: <CAMuHMdWyr_GzDzGBoYn3T85Dqe65FCKd0Y_xvEwwS6UY7naPXQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.11-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 11:06 AM, Michal Simek <monstr@monstr.eu> wrote:
> On 07/16/2013 09:50 AM, Geert Uytterhoeven wrote:
>>   + drivers/spi/spi-xilinx.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 105:2
>>   + drivers/spi/spi-xilinx.c: error: implicit declaration of function 'ioread32be' [-Werror=implicit-function-declaration]:  => 115:2
>>   + drivers/spi/spi-xilinx.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 100:2
>>   + drivers/spi/spi-xilinx.c: error: implicit declaration of function 'iowrite32be' [-Werror=implicit-function-declaration]:  => 110:2

cris-allyesconfig/cris-allmodconfig, so this can be safely ignored (by you ;-)

>>   + drivers/video/xilinxfb.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'phys_addr_t' [-Wformat]:  => 344:3

ppc44x_defconfig

> How to find out which target is causing these warnings?

It's indeed a bit difficult without the full logs. /me needs to study kup.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
