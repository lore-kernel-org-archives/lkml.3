Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbaKESXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:23:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:47465 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaKESW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:22:58 -0500
Message-ID: <545A6AFC.40508@infradead.org>
Date: Wed, 05 Nov 2014 10:22:52 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, alexei.starovoitov@gmail.com
Subject: Re: [PATCH/v2] [trivial] treewide: Fix typo in printk and Kconfig
References: <CAADnVQLye-wFpnRgnSd6n=9awSA3Q_HshaMkZ=rdQ1C-zEtpFA@mail.gmail.com> <1415194008-25550-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1415194008-25550-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/14 05:26, Masanari Iida wrote:
> This patch fix spelling typo in printk and Kconfig within
> various part of kernel sources.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  arch/mips/cavium-octeon/setup.c                                | 4 ++--
>  arch/mips/pci/pci-octeon.c                                     | 2 +-
>  arch/powerpc/kvm/e500_mmu_host.c                               | 6 +++---
>  drivers/isdn/mISDN/l1oip_core.c                                | 2 +-
>  drivers/media/pci/ttpci/budget-patch.c                         | 2 +-
>  drivers/s390/char/tape_3590.c                                  | 4 ++--
>  drivers/scsi/megaraid/megaraid_sas_base.c                      | 2 +-
>  drivers/target/target_core_xcopy.c                             | 2 +-
>  drivers/tty/serial/Kconfig                                     | 2 +-
>  drivers/usb/gadget/function/f_hid.c                            | 2 +-
>  drivers/usb/host/ehci-sysfs.c                                  | 2 +-
>  drivers/usb/host/fotg210-hcd.c                                 | 2 +-
>  drivers/usb/host/fusbh200-hcd.c                                | 2 +-
>  fs/reiserfs/journal.c                                          | 2 +-
>  tools/usb/ffs-aio-example/multibuff/device_app/aio_multibuff.c | 2 +-
>  15 files changed, 19 insertions(+), 19 deletions(-)


-- 
~Randy
