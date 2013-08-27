Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3H0RzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:55:14 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:35548 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3H0RzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:55:13 -0400
Date: Tue, 27 Aug 2013 19:55:02 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Build regressions/improvements in v3.11-rc7
In-Reply-To: <alpine.DEB.2.02.1308271951240.13016@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1308271954100.13120@ayla.of.borg>
References: <alpine.DEB.2.02.1308271951240.13016@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.11-rc7 to v3.11-rc6[3], the summaries are:
>   - build errors: +15/-9

  + /scratch/kisskb/src/arch/powerpc/sysdev/mpic.c: error: case label does not reduce to an integer constant:  => 892:9, 904:9, 900:9, 896:9
  + /scratch/kisskb/src/drivers/net/ethernet/amd/lance.c: error: implicit declaration of function 'isa_bus_to_virt' [-Werror=implicit-function-declaration]:  => 1204:6
  + /scratch/kisskb/src/drivers/net/ethernet/amd/lance.c: error: implicit declaration of function 'isa_virt_to_bus' [-Werror=implicit-function-declaration]:  => 575:2
  + /scratch/kisskb/src/drivers/net/ethernet/amd/ni65.c: error: implicit declaration of function 'isa_bus_to_virt' [-Werror=implicit-function-declaration]:  => 756:4
  + /scratch/kisskb/src/drivers/net/ethernet/amd/ni65.c: error: implicit declaration of function 'isa_virt_to_bus' [-Werror=implicit-function-declaration]:  => 586:2
  + /scratch/kisskb/src/drivers/net/ethernet/cirrus/cs89x0.c: error: implicit declaration of function 'isa_virt_to_bus' [-Werror=implicit-function-declaration]:  => 896:1
  + /scratch/kisskb/src/drivers/scsi/aha1542.c: error: implicit declaration of function 'isa_page_to_bus' [-Werror=implicit-function-declaration]:  => 674:4
  + /scratch/kisskb/src/drivers/scsi/aha1542.c: error: implicit declaration of function 'isa_virt_to_bus' [-Werror=implicit-function-declaration]:  => 477:3
  + /scratch/kisskb/src/drivers/scsi/wd7000.c: error: implicit declaration of function 'isa_bus_to_virt' [-Werror=implicit-function-declaration]:  => 1055:2
  + /scratch/kisskb/src/drivers/scsi/wd7000.c: error: implicit declaration of function 'isa_page_to_bus' [-Werror=implicit-function-declaration]:  => 1121:4
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A

powerpc-randconfig

  + /scratch/kisskb/src/drivers/usb/host/ohci-pci.c: error: 'ohci_resume' undeclared (first use in this function):  => 310:34
  + /scratch/kisskb/src/drivers/usb/host/ohci-pci.c: error: 'ohci_suspend' undeclared (first use in this function):  => 309:35

20 configs suppressed ;-)

> [1] http://kisskb.ellerman.id.au/kisskb/head/6579/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6556/ (all 120 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
