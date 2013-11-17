Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3KQRIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 12:08:23 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:33166 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751591Ab3KQRIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 12:08:18 -0500
Date: Sun, 17 Nov 2013 12:08:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Yang Bai <hamo.by@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts: Have make TAGS not include structure members
Message-ID: <20131117120816.41fe2528@gandalf.local.home>
In-Reply-To: <CAMuHMdWNh2L56FhDbKfC7TtdHp8=EY2ms_T+=9Xyczz3D-PF=w@mail.gmail.com>
References: <20131115093645.6dc03918@gandalf.local.home>
	<CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
	<20131117092731.75b091bd@gandalf.local.home>
	<CAMuHMdWNh2L56FhDbKfC7TtdHp8=EY2ms_T+=9Xyczz3D-PF=w@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Nov 2013 16:19:53 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

 
> Thanks! Now I have to look into my vim setup, why it doesn't do the
> above...
> 

$ vim --version
VIM - Vi IMproved 7.4 (2013 Aug 10, compiled Sep 11 2013 12:28:07)

And from the ctags man pages, I did:

:ta dev_name

and it gave me a list of tags.

  # pri kind tag               file
  1 F   m    dev_name          drivers/clk/samsung/clk.h
               struct:samsung_clock_alias
               const char  *dev_name;
  2 F   m    dev_name          drivers/clk/samsung/clk.h
               struct:samsung_div_clock
               const char  *dev_name;
  3 F   m    dev_name          drivers/clk/samsung/clk.h
               struct:samsung_gate_clock
               const char  *dev_name;
  4 F   m    dev_name          drivers/clk/samsung/clk.h
               struct:samsung_mux_clock
               const char  *dev_name;
  5 F   m    dev_name          drivers/clk/samsung/clk.h
               struct:samsung_pll_clock
               const char  *dev_name;
  6 F   m    dev_name          drivers/edac/edac_core.h
               struct:edac_device_ctl_info
               const char *dev_name; /* pci/platform/etc... name */
  7 F   m    dev_name          drivers/edac/edac_core.h
               struct:edac_pci_ctl_info
               const char *dev_name; /* pci/platform/etc... name */
  8 F   m    dev_name          drivers/infiniband/hw/cxgb3/cxio_hal.h
               struct:cxio_rdev
               char dev_name[T3_MAX_DEV_NAME_LEN];
  9 F   m    dev_name          drivers/pinctrl/core.h
               struct:pinctrl_setting
               const char *dev_name;
 10 F   m    dev_name          drivers/scsi/dpt/dpti_i2o.h
               struct:i2o_device
               char dev_name[8];  /* linux /dev name if available */
 11 F   v    dev_name          drivers/target/target_core_stat.c
               DEV_STAT_SCSI_TRANSPORT_ATTR_RO(dev_name);
 12 F   m    dev_name          drivers/video/cyber2000fb.h
               struct:cyberpro_info
               char  dev_name[32];
 13 F   m    dev_name          drivers/video/sticore.h
               struct:sti_conf_outptr
               u8 dev_name[STI_DEV_NAME_LENGTH]; /* null terminated product name */
 14 F   m    dev_name          include/linux/device.h
               struct:bus_type
               const char  *dev_name;
 15 F   f    dev_name          include/linux/device.h
               static inline const char *dev_name(const struct device *dev)
 16 F   m    dev_name          include/linux/edac.h
               struct:mem_ctl_info
               const char *dev_name;
 17 F   m    dev_name          include/linux/mfd/ti_ssp.h
               struct:ti_ssp_dev_data
               const char *dev_name;
 18 F   m    dev_name          include/linux/netpoll.h
               struct:netpoll
               char dev_name[IFNAMSIZ];
 19 F   m    dev_name          include/linux/omap-dma.h
               struct:omap_dma_lch
               const char *dev_name;
 20 F   m    dev_name          include/linux/phy/phy.h
               struct:phy_consumer
               const char *dev_name;
 21 F   m    dev_name          include/linux/pinctrl/machine.h
               struct:pinctrl_map
               const char *dev_name;
 22 F   m    dev_name          include/linux/regulator/machine.h
               struct:regulator_consumer_supply
-- More --



-- Steve

