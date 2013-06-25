Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3FYIz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:55:26 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60631 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3FYIzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:55:22 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130625184420.b811089a069c63ccd3721d68@canb.auug.org.au>
References: <20130625184420.b811089a069c63ccd3721d68@canb.auug.org.au>
Date: Tue, 25 Jun 2013 10:55:20 +0200
Message-ID: <CA+icZUUH7AeR7OSm-SB56AGRiE815tTkQW9fFkKzyrSvzs3Etg@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 25
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 10:44 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130624:
>
> The vfs tree lost its build failure.
>
> The net-next tree gained a conflict against the net tree.
>
> The usb tree gained a conflict against the devicetree tree.
>
> The staging tree lost its build failure.
>
> The msm tree gained a conflict against the arm-soc tree.
>
> The samsung tree gained a conflict against the tip tree.
>
> The akpm tree lost a patch that turned up elsewhere and gained a conflict
> against the samsung tree.
>
> ----------------------------------------------------------------------------
>

[ CC linux-kbuild folks ]

Not sure what's going on, but I get this with today's Linux-Next.
( Yesterday's next-20130624 was OK. )

$ LANG=C LC_ALL=C  yes "" | make oldconfig && LANG=C LC_ALL=C make
silentoldconfig </dev/null
...
#
# configuration written to .config
#
scripts/kconfig/conf --silentoldconfig Kconfig
*
* Restart config...
*
*
* Bus options (PCI etc.)
*
PCI support (PCI) [Y/n/?] y
  Support mmconfig PCI config space access (PCI_MMCONFIG) [Y/n] y
  Read CNB20LE Host Bridge Windows (PCI_CNB20LE_QUIRK) [N/y/?] n
  PCI Express support (PCIEPORTBUS) [Y/n/?] y
    PCI Express Hotplug driver (HOTPLUG_PCI_PCIE) [Y/n/m/?] y
    Root Port Advanced Error Reporting support (PCIEAER) [Y/n/?] y
      PCI Express ECRC settings control (PCIE_ECRC) [N/y/?] n
      PCIe AER error injector support (PCIEAER_INJECT) [N/m/y/?] n
    PCI Express ASPM control (PCIEASPM) [Y/n/?] y
      Debug PCI Express ASPM (PCIEASPM_DEBUG) [N/y/?] n
      Default ASPM policy
      > 1. BIOS default (PCIEASPM_DEFAULT)
        2. Powersave (PCIEASPM_POWERSAVE)
        3. Performance (PCIEASPM_PERFORMANCE)
      choice[1-3]: 1
Message Signaled Interrupts (MSI and MSI-X) (PCI_MSI) [Y/?] y
PCI Debugging (PCI_DEBUG) [N/y/?] n
Enable PCI resource re-allocation detection (PCI_REALLOC_ENABLE_AUTO) [Y/n/?] y
PCI Stub driver (PCI_STUB) [M/n/y/?] m
Interrupts on hypertransport devices (HT_IRQ) [Y/n/?] y
PCI IOV support (PCI_IOV) [Y/n/?] y
PCI PRI support (PCI_PRI) [Y/?] y
PCI PASID support (PCI_PASID) [Y/?] y
PCI IO-APIC hotplug support (PCI_IOAPIC) [Y/n/m] y
ISA-style DMA support (ISA_DMA_API) [Y/n/?] y
RapidIO support (RAPIDIO) [Y/n/?] y
  IDT Tsi721 PCI Express SRIO Controller support (RAPIDIO_TSI721) [Y/n/?] y
  Discovery timeout duration (seconds) (RAPIDIO_DISC_TIMEOUT) [30] 30
  Enable RapidIO Input/Output Ports (RAPIDIO_ENABLE_RX_TX_PORTS) [N/y/?] n
  DMA Engine support for RapidIO (RAPIDIO_DMA_ENGINE) [Y/n/?] y
  RapidIO subsystem debug messages (RAPIDIO_DEBUG) [N/y/?] n
  Enumeration method [M/y/?] (NEW) aborted!

Console input/output is redirected. Run 'make oldconfig' to update
configuration.

make[1]: *** [silentoldconfig] Error 1
make: *** [silentoldconfig] Error 2

- Sedat -
