Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaDEVpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:45:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53827 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbaDEVpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:45:04 -0400
Message-ID: <5340795C.9010802@infradead.org>
Date: Sat, 05 Apr 2014 14:45:00 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Carlos Garcia <carlos@cgarcia.org>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH v2] Documentation: spelling error changes
References: <1396302992-13582-1-git-send-email-carlos@cgarcia.org> <1396665060-22864-1-git-send-email-carlos@cgarcia.org>
In-Reply-To: <1396665060-22864-1-git-send-email-carlos@cgarcia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 07:31 PM, Carlos Garcia wrote:
> Fixed multiple spelling errors.
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Carlos E. Garcia <carlos@cgarcia.org>

Jiri,

Would you merge this thru trivial, please?
or would you rather that I merge it?

Thanks, Carlos.

> ---
>  Documentation/DMA-attributes.txt                             |  2 +-
>  Documentation/devicetree/bindings/arm/omap/omap.txt          |  2 +-
>  Documentation/devicetree/bindings/bus/mvebu-mbus.txt         |  2 +-
>  Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt     |  2 +-
>  Documentation/devicetree/bindings/mmc/k3-dw-mshc.txt         |  2 +-
>  Documentation/devicetree/bindings/mmc/samsung-sdhci.txt      |  2 +-
>  Documentation/devicetree/bindings/mtd/gpmc-nand.txt          |  2 +-
>  Documentation/devicetree/bindings/mtd/gpmc-nor.txt           |  2 +-
>  Documentation/devicetree/bindings/mtd/gpmc-onenand.txt       |  2 +-
>  .../devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt    | 12 ++++++------
>  Documentation/devicetree/bindings/powerpc/4xx/reboot.txt     |  2 +-
>  Documentation/devicetree/bindings/powerpc/fsl/dcsr.txt       |  2 +-
>  Documentation/devicetree/bindings/regulator/regulator.txt    |  2 +-
>  Documentation/devicetree/bindings/spi/spi-bus.txt            |  2 +-
>  Documentation/dma-buf-sharing.txt                            |  2 +-
>  Documentation/dynamic-debug-howto.txt                        |  2 +-
>  Documentation/edac.txt                                       |  2 +-
>  Documentation/fb/sm501.txt                                   |  2 +-
>  Documentation/fb/sstfb.txt                                   |  2 +-
>  Documentation/filesystems/proc.txt                           |  4 ++--
>  Documentation/filesystems/sharedsubtree.txt                  |  2 +-
>  Documentation/gpio/consumer.txt                              |  2 +-
>  Documentation/hid/uhid.txt                                   |  2 +-
>  Documentation/input/alps.txt                                 |  2 +-
>  Documentation/input/input.txt                                |  2 +-
>  Documentation/mtd/nand/pxa3xx-nand.txt                       |  2 +-
>  Documentation/networking/can.txt                             |  2 +-
>  Documentation/networking/dccp.txt                            |  2 +-
>  Documentation/powerpc/transactional_memory.txt               |  2 +-
>  Documentation/rbtree.txt                                     |  2 +-
>  Documentation/rfkill.txt                                     |  2 +-
>  Documentation/robust-futexes.txt                             |  2 +-
>  Documentation/s390/monreader.txt                             |  2 +-
>  Documentation/security/Yama.txt                              |  2 +-
>  Documentation/sound/alsa/ALSA-Configuration.txt              |  4 ++--
>  Documentation/trace/events.txt                               |  2 +-
>  Documentation/usb/mass-storage.txt                           |  2 +-
>  Documentation/virtual/kvm/api.txt                            |  2 +-
>  Documentation/vm/transhuge.txt                               |  4 ++--
>  Documentation/x86/earlyprintk.txt                            |  2 +-
>  Documentation/x86/i386/IO-APIC.txt                           |  2 +-
>  41 files changed, 49 insertions(+), 49 deletions(-)


-- 
~Randy
