Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaDEAQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:16:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41352 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaDEAQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:16:35 -0400
Message-ID: <533F4B60.1020702@infradead.org>
Date: Fri, 04 Apr 2014 17:16:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Carlos Garcia <carlos@cgarcia.org>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] Documentation: spelling error changes
References: <1396302992-13582-1-git-send-email-carlos@cgarcia.org>
In-Reply-To: <1396302992-13582-1-git-send-email-carlos@cgarcia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 02:56 PM, Carlos Garcia wrote:
> Fixed multiple spelling errors.
> 
> Signed-off-by: Carlos E. Garcia <carlos@cgarcia.org>
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

> diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
> index e5a4d1b..0ff87d1 100644
> --- a/Documentation/devicetree/bindings/spi/spi-bus.txt
> +++ b/Documentation/devicetree/bindings/spi/spi-bus.txt
> @@ -61,7 +61,7 @@ contain the following properties.
>                        used for MISO. Defaults to 1 if not present.
>  
>  Some SPI controllers and devices support Dual and Quad SPI transfer mode.
> -It allows data in SPI system transfered in 2 wires(DUAL) or 4 wires(QUAD).
> +It allows data in SPI system transferred in 2 wires(DUAL) or 4 wires(QUAD).

The spelling change is correct, but that sentence is still awkward.
How about:

  It allows data in the SPI system to be transferred in 2 wires (DUAL) or 4 wires (QUAD).


>  Now the value that spi-tx-bus-width and spi-rx-bus-width can receive is
>  only 1(SINGLE), 2(DUAL) and 4(QUAD).
>  Dual/Quad mode is not allowed when 3-wire mode is used.

> diff --git a/Documentation/vm/transhuge.txt b/Documentation/vm/transhuge.txt
> index 4a63953..aeea1b14 100644
> --- a/Documentation/vm/transhuge.txt
> +++ b/Documentation/vm/transhuge.txt
> @@ -360,13 +360,13 @@ on any tail page, would mean having to split all hugepages upfront in
>  get_user_pages which is unacceptable as too many gup users are
>  performance critical and they must work natively on hugepages like
>  they work natively on hugetlbfs already (hugetlbfs is simpler because
> -hugetlbfs pages cannot be splitted so there wouldn't be requirement of
> +hugetlbfs pages cannot be splitt so there wouldn't be requirement of

                             split

>  accounting the pins on the tail pages for hugetlbfs). If we wouldn't
>  account the gup refcounts on the tail pages during gup, we won't know
>  anymore which tail page is pinned by gup and which is not while we run
>  split_huge_page. But we still have to add the gup pin to the head page
>  too, to know when we can free the compound page in case it's never
> -splitted during its lifetime. That requires changing not just
> +splitt during its lifetime. That requires changing not just

   split

>  get_page, but put_page as well so that when put_page runs on a tail
>  page (and only on a tail page) it will find its respective head page,
>  and then it will decrease the head page refcount in addition to the


Carlos, would you make those few changes and send a v3?
And with those changes, you can include this line:
Acked-by: Randy Dunlap <rdunlap@infradead.org>


thanks,
-- 
~Randy
