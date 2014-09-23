Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaIWIx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:53:58 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:62510 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaIWIx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <1411461080-4061-1-git-send-email-geert@linux-m68k.org>
References: <1411461080-4061-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 23 Sep 2014 10:53:54 +0200
X-Google-Sender-Auth: s3hY7The_bWx0H5kcy19GpZEM-8
Message-ID: <CAMuHMdUcuKUpwB9K4BJY1U_rwLiG_Q4DgHZ5eqWBsiWjDpykXw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.17-rc6 (take two)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:31 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.17-rc6[1]  to v3.17-rc5[3], the summaries are:
>   - build errors: +9/-10

  + /scratch/kisskb/src/drivers/net/ethernet/amd/lance.c: error:
implicit declaration of function 'isa_bus_to_virt'
[-Werror=implicit-function-declaration]:  => 1204:6
  + /scratch/kisskb/src/drivers/net/ethernet/amd/lance.c: error:
implicit declaration of function 'isa_virt_to_bus'
[-Werror=implicit-function-declaration]:  => 575:2
  + /scratch/kisskb/src/drivers/net/ethernet/cirrus/cs89x0.c: error:
implicit declaration of function 'isa_virt_to_bus'
[-Werror=implicit-function-declaration]:  => 892:3
  + /scratch/kisskb/src/drivers/scsi/aha1542.c: error: implicit
declaration of function 'isa_page_to_bus'
[-Werror=implicit-function-declaration]:  => 674:4
  + /scratch/kisskb/src/drivers/scsi/aha1542.c: error: implicit
declaration of function 'isa_virt_to_bus'
[-Werror=implicit-function-declaration]:  => 477:3
  + /scratch/kisskb/src/drivers/scsi/wd7000.c: error: implicit
declaration of function 'isa_bus_to_virt'
[-Werror=implicit-function-declaration]:  => 1055:2
  + /scratch/kisskb/src/drivers/scsi/wd7000.c: error: implicit
declaration of function 'isa_page_to_bus'
[-Werror=implicit-function-declaration]:  => 1121:4
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7891/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7872/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
