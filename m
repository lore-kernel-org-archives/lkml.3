Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaCaDs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 23:48:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39587 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaCaDs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 23:48:27 -0400
Message-ID: <5338E585.8030805@infradead.org>
Date: Sun, 30 Mar 2014 20:48:21 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Carlos <carlos@cgarcia.org>, rob@landley.net
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] Documentation: trivial spelling error changes
References: <1396140859-17645-1-git-send-email-carlos@cgarcia.org>
In-Reply-To: <1396140859-17645-1-git-send-email-carlos@cgarcia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2014 05:54 PM, Carlos wrote:
> Fixed multiple spelling errors.
> 
> Signed-off-by: Carlos E. Garcia <carlos@cgarcia.org>
> ---
>  Documentation/DMA-attributes.txt                             |  2 +-
>  Documentation/block/biodoc.txt                               |  8 ++++----
>  Documentation/block/cfq-iosched.txt                          |  2 +-
>  Documentation/cgroups/net_prio.txt                           |  4 ++--
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
>  Documentation/filesystems/path-lookup.txt                    |  2 +-
>  Documentation/filesystems/proc.txt                           |  4 ++--
>  Documentation/filesystems/sharedsubtree.txt                  |  2 +-
>  Documentation/gpio/consumer.txt                              |  2 +-
>  Documentation/hid/uhid.txt                                   |  2 +-
>  Documentation/input/alps.txt                                 |  2 +-
>  Documentation/input/input.txt                                |  2 +-
>  Documentation/ioctl/hdio.txt                                 |  4 ++--
>  Documentation/mtd/nand/pxa3xx-nand.txt                       |  2 +-
>  Documentation/networking/can.txt                             | 10 +++++-----
>  Documentation/networking/dccp.txt                            |  2 +-
>  Documentation/networking/ip-sysctl.txt                       | 10 +++++-----
>  Documentation/powerpc/transactional_memory.txt               |  2 +-
>  Documentation/rbtree.txt                                     |  2 +-
>  Documentation/rfkill.txt                                     |  2 +-
>  Documentation/robust-futexes.txt                             |  2 +-
>  Documentation/s390/monreader.txt                             |  2 +-
>  Documentation/scsi/53c700.txt                                |  2 +-
>  Documentation/scsi/dc395x.txt                                |  2 +-
>  Documentation/scsi/ncr53c8xx.txt                             |  8 ++++----
>  Documentation/scsi/scsi_mid_low_api.txt                      |  8 ++++----
>  Documentation/scsi/sym53c8xx_2.txt                           |  6 +++---
>  Documentation/scsi/tmscsim.txt                               | 10 +++++-----
>  Documentation/security/Yama.txt                              |  2 +-
>  Documentation/serial/tty.txt                                 |  4 ++--
>  Documentation/sound/alsa/ALSA-Configuration.txt              |  4 ++--
>  Documentation/sysctl/net.txt                                 |  2 +-
>  Documentation/trace/events.txt                               |  2 +-
>  Documentation/usb/WUSB-Design-overview.txt                   |  2 +-
>  Documentation/usb/mass-storage.txt                           |  2 +-
>  Documentation/virtual/kvm/api.txt                            |  2 +-
>  Documentation/vm/transhuge.txt                               |  4 ++--
>  Documentation/workqueue.txt                                  |  2 +-
>  Documentation/x86/earlyprintk.txt                            |  2 +-
>  Documentation/x86/i386/IO-APIC.txt                           |  2 +-
>  57 files changed, 91 insertions(+), 91 deletions(-)
> 
> diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
> index 2101e71..104589b 100644
> --- a/Documentation/block/biodoc.txt
> +++ b/Documentation/block/biodoc.txt
> @@ -732,7 +732,7 @@ direct access requests which only specify rq->buffer without a valid rq->bio)
>  3.2.5.1 Tag helpers
>  
>  Block now offers some simple generic functionality to help support command
> -queueing (typically known as tagged command queueing), ie manage more than
> +queuing (typically known as tagged command queuing), ie manage more than


Hi,

I think that it's going to be difficult to spell "queu[e]ing" consistently
in all of the kernel documentation.  SCSI Tagged Command Queuing seems to be
usually spelled without the 'e', but for Queueing Theory, it's a toss-up (can
be spelled either way), so the extra 'e' is not incorrect.


>  one outstanding command on a queue at any given time.
>  
>  	blk_queue_init_tags(struct request_queue *q, int depth)

> diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
> index e2c7f1e..941c0bb 100644
> --- a/Documentation/devicetree/bindings/regulator/regulator.txt
> +++ b/Documentation/devicetree/bindings/regulator/regulator.txt
> @@ -12,7 +12,7 @@ Optional properties:
>  - regulator-allow-bypass: allow the regulator to go into bypass mode
>  - <name>-supply: phandle to the parent supply/regulator node
>  - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
> -  For hardwares which support disabling ramp rate, it should be explicitly
> +  For hardware which support disabling ramp rate, it should be explicitly

                        supports

>    intialised to zero (regulator-ramp-delay = <0>) for disabling ramp delay.
>  - regulator-enable-ramp-delay: The time taken, in microseconds, for the supply
>    rail to reach the target voltage, plus/minus whatever tolerance the board

> diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
> index 46325eb..4227712 100644
> --- a/Documentation/dynamic-debug-howto.txt
> +++ b/Documentation/dynamic-debug-howto.txt
> @@ -321,7 +321,7 @@ nullarbor:~ # echo -n 'func svc_process -p' >
>  nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
>  				<debugfs>/dynamic_debug/control
>  
> -// enable messages in files of which the pathes include string "usb"
> +// enable messages in files of which the path include string "usb"

                      Either:               paths include
                      or:                   path includes

>  nullarbor:~ # echo -n '*usb* +p' > <debugfs>/dynamic_debug/control
>  
>  // enable all messages


The other changes look good.

Please make a few more corrections and resend the patch.

thanks,
-- 
~Randy
