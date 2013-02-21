Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab3BUSk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:40:58 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48006 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab3BUSkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:40:53 -0500
Date: Thu, 21 Feb 2013 10:41:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc patches for 3.9-rc1
Message-ID: <20130221184122.GA24848@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.9-rc1

for you to fetch changes up to 29e5507ae4ab34397f538f06b7070c81a4e4a2bf:

  w1: w1_therm: Add force-pullup option for "broken" sensors (2013-02-18 13:55:24 -0800)

----------------------------------------------------------------
Char/Misc driver patches for 3.9-rc1

Here's the big char/misc driver patches for 3.9-rc1.

Nothing major here, just lots of different driver updates (mei, hyperv, ipack,
extcon, vmci, etc.).

All of these have been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alberto Garcia (2):
      ipack/devices/ipoctal: Fix race condition during Tx
      ipack/devices/ipoctal: don't check if nb_bytes is < 0

Alexey Khoroshilov (2):
      pcmcia: synclink_cs: fix error handling in mgslpc_probe()
      pcmcia: synclink_cs: cleanup checkpatch warnings

Andy King (5):
      VMCI: Add PCI as a dependency
      VMCI: Remove dependency on BLOCK I/O
      VMCI: Fix deref before NULL-check of queuepair ptr
      VMCI: Fix "always true condition"
      VMCI: Fix broken context ID retrieval

Ben Hutchings (1):
      tools/hv: Fix permissions of created directory and files

Chanwoo Choi (19):
      extcon: max77693: Remove duplicate code by making function
      extcon: max77693: Add support MHL_TA cable for charging battery
      extcon: max77693: Add support jig cable
      extcon: max77693: Add support dock device and buttons
      extcon: max77693: Check the state/type of cable after boot completed
      extcon: max8997/max77693: Support IRQF_NO_SUSPEND flag for interrupt
      extcon: max77693: Set default uart/usb path by using platform data
      extcon: max77693: Fix bug when detecting MHL/Dock-Audio with USB/TA cable
      extcon: max77693: Add support Dock-Smart device for desktop mode
      extcon: max77693: Fix bug of build error related to INPUT subsystem
      extcon: gpio: Rename filename of extcon-gpio.c according to kernel naming style
      extcon: max77693: Convert to devm_input_allocate_device()
      extcon: max77693: Remove unnecessary goto statement to improve readability
      extcon: max8997: Move defined constant to header file
      extcon: max8997: Remove duplicate code related to set H/W line path
      extcon: max8997: Set default of ADC debounce time during initialization
      extcon: max8997: Consolidate duplicate code for checking ADC/CHG cable type
      extcon: max8997: Set default UART/USB path on probe
      extcon: max8997: Use workqueue to check cable state after completing boot of platform

Charles Keepax (2):
      extcon: arizona: Remove extra jack flip increment
      extcon: arizona: Clear _trig_sts bits after jack detection

Dan Carpenter (1):
      pcmcia: i82092: fix i82092aa_pci_remove()

David Rientjes (1):
      drivers, vmci: Fix build error

David Stevenson (1):
      w1_therm: Retries: remove old code add CRC

Dmitry Torokhov (2):
      VMCI: rename PPNset to ppn_set to avoid camel case
      VMCI: include slab.h into files using kmalloc/kfree

Emilio G. Cota (1):
      vme: add missing put_device() after device_register() fails

Fengguang Wu (2):
      Drivers: hv: vmbus_flow_handler() can be static
      Drivers: char: exynos_rng_pm_ops can be static

George Zhang (12):
      VMCI: context implementation.
      VMCI: datagram implementation.
      VMCI: doorbell implementation.
      VMCI: device driver implementaton.
      VMCI: event handling implementation.
      VMCI: handle array implementation.
      VMCI: queue pairs implementation.
      VMCI: resource object implementation.
      VMCI: routing implementation.
      VMCI: guest side driver implementation.
      VMCI: host side driver implementation.
      VMCI: Some header and config files.

Greg Kroah-Hartman (7):
      Merge tag 'extcon-for-3.9' of git://git.kernel.org/.../chanwoo/extcon into char-misc-next
      misc: lattice-ecp3-config.c: remove __dev* markings
      ntb: remove __dev* markings
      Merge 3.8-rc4 into char-misc-next
      Merge 3.8-rc5 into char-misc-next
      Merge tag 'extcon-arizona-3.9' of git://git.kernel.org/.../broonie/misc into char-misc-next
      Merge tag 'extcon-for-3.9' of git://git.kernel.org/.../chanwoo/extcon into char-misc-next

Hans Grob (1):
      drivers/char/mem.c: fix small coding style issues

Harald Hoyer (1):
      CREDITS: update email and address of Harald Hoyer

Hauke Mehrtens (1):
      w1-gpio: fix section mismatch

Heiko Carstens (1):
      drivers/misc/cb710: add missing GENERIC_HARDIRQS dependency

Jason Wang (1):
      tools: hv: fix a typo in hv_set_ifconfig.sh

Jean Delvare (1):
      pcmcia/vrc4171: Add missing spinlock init

Jon Mason (20):
      PCI-Express Non-Transparent Bridge Support
      net: Add support for NTB virtual ethernet device
      NTB: Handle ntb client device probes without present hardware
      NTB: correct memory barrier
      NTB: separate transmit and receive windows
      NTB: No sleeping in interrupt context
      NTB: use simple_open for debugfs
      NTB: namespacecheck cleanups
      NTB: whitespace cleanups
      NTB: correct stack usage warning in debugfs_read
      NTB: Remove reads across NTB
      NTB: Out of free receive entries issue
      NTB: Update Version
      ntb_netdev: remove init/exit from probe/remove
      ntb_netdev: correct skb leak
      ntb_netdev: remove tx timeout
      ntb_netdev: improve logging
      ntb_netdev: Update Version
      NTB: disable x86_32 support
      NTB: Fix Sparse Warnings

Julia Lawall (3):
      drivers/w1/masters/ds1wm.c: use devm_ functions
      drivers/w1/masters/mxc_w1.c: use devm_ functions
      drivers/ipack/devices/ipoctal.c: adjust duplicate test

K. Y. Srinivasan (38):
      Drivers: hv: Implement routines for read side signaling optimization
      Drivers: hv: Add state to manage batched reading
      Drivers: hv: Turn off batched reading for util drivers
      Drivers: hv: Optimize signaling in the read path
      Drivers: hv: Optimize the signaling on the write path
      Drivers: hv: Get rid of hv_get_ringbuffer_interrupt_mask()
      Drivers: hv: Support handling multiple VMBUS versions
      Drivers: hv: Update the ring buffer structure to match win8 functionality
      Drivers: hv: Extend/modify vmbus_channel_offer_channel for win7 and beyond
      Drivers: hv: Save and export negotiated vmbus version
      Drivers: hv: Change the signature for hv_signal_event()
      Drivers: hv: Change the signature of vmbus_set_event()
      Drivers: hv: Move vmbus version definitions to hyperv.h
      Drivers: hv: Manage signaling state on a per-connection basis
      Drivers: hv: Cleanup vmbus_set_event() to support win7 and beyond
      Drivers: hv: Setup a mapping for Hyper-V's notion cpu ID
      Drivers: hv: Add state to manage incoming channel interrupt load
      Drivers: hv: Modify the interrupt handling code to support win8 and beyond
      Drivers: hv: Add code to distribute channel interrupt load
      Drivers: hv: Get rid of the unused global signaling state
      Drivers: hv: Get rid of unnecessary request for offers
      Drivers: hv: Manage event tasklets on per-cpu basis
      Drivers: hv: Handle vmbus interrupts concurrently on all cpus
      Drivers: hv: Add a check to deal with spurious interrupts
      Drivers: hv: Enable protocol negotiation with win8 hosts
      Drivers: hv: Implement flow management on the send side
      Drivers: hv: Capture the host build information
      Drivers: hv: Cleanup and consolidate reporting of build/version info
      Drivers: hv: Bind all vmbbus interrupts to the boot CPU
      Drivers: hv: vmbus: Consolidate all offer GUID definitions in hyperv.h
      Drivers: hv: Use consolidated GUID definitions
      Drivers: net: hyperv: Use the consolidated GUID definition
      Drivers: scsi: storvsc: Use the consolidated GUID definition
      Drivers: hid: hid-hyperv: Use consolidated GUID definitions
      Drivers: hv: Execute shutdown in a thread context
      Drivers: hv: balloon: Make adjustments to the pressure report
      Drivers: hv: balloon: Add a parameter to delay pressure reporting
      Drivers: hv: balloon: Prevent the host from ballooning the guest too low

Luciano Coelho (1):
      Revert "drivers/misc/ti-st: remove gpio handling"

Mark Brown (20):
      extcon: arizona: Convert to devm_input_allocate_device()
      extcon: arizona: Remove duplicate mic ramp configuration
      extcon: arizona: Only set GPIO if it has been requested
      extcon: arizona: Allow configuration of MICBIAS rise time
      extcon: arizona: Use microphone clamp function if available
      extcon: arizona: Support use of GPIO5 as an input to jack detection
      extcon: arizona: Enable basic headphone identification
      extcon: Simple code motion supporting future work.
      extcon: arizona: Support HPDET based accessory identification
      extcon: arizona: Support direct microphone measurement via HPDET
      mfd: wm5102: Add microphone clamp control registers
      extcon: arizona: Disable debouce for accessory removal detection
      extcon: arizona: Retry failed HP measurements
      extcon: arizona: Remove duplicate rate configuration
      extcon: arizona: Support additional configuration of microphone detection
      extcon: arizona: Use regulated mode for microphone supply when detecting
      extcon: arizona: Add some debounce time before starting HPDET identification
      extcon: arizona: Don't HPDET magic when headphones are enabled
      extcon: arizona: Always take the first HPDET reading as the final one
      extcon: arizona: Use MICDET for final microphone identification

Michael Arndt (2):
      w1: ds2482: Added 1-Wire pull-up support to the driver
      w1: w1_therm: Add force-pullup option for "broken" sensors

Sachin Kamat (3):
      extcon: max8997: Make max8997_extcon_cable static
      extcon: max8997: Remove unreachable code
      extcon: max77693: Make max77693_extcon_cable static

Samuel Iglesias Gonsalvez (11):
      ipack/devices/ipoctal: fix kernel bug when using pppd
      ipack/devices/ipoctal: remove wait_queue and atomic_t board_write
      ipack/devices/ipoctal: setup TTY_NORMAL flag for each character.
      ipack/devices/ipoctal: rework disable TX when the TX buffer is empty
      ipack/devices/ipoctal: avoid re-enable RX two times.
      ipack/devices/ipoctal: ack IRQ before processing it
      ipack/devices/ipoctal: protect the channel data processing with a spinlock
      ipack/devices/ipoctal: remove redundant tty_flip_buffer_push()
      ipack/devices/ipoctal: add rx_enable flag
      ipack/devices/ipoctal: added shutdown callback
      ipack/devices/ipoctal: add missing rx_enable = 1

Sedat Dilek (1):
      mei: Fix some more kernel-doc typos in hw-me.c

Stefan Roese (1):
      misc: Add Lattice ECP3 FPGA configuration via SPI

Stephen Hemminger (1):
      uio-howto: example bug

Tomas Hozza (3):
      tools/hv: Fix /var subdirectory
      tools: hv: Fix how ifcfg-* file is created
      tools: hv: Use CLOEXEC when opening kvp_pool files

Tomas Winkler (43):
      mei: drop redundant length parameter from mei_write_message function
      mei: use unified format for printing mei message header
      mei: move internal host clients ids to mei_dev.h from hw.h
      mei: extract device dependent constants into hw-me.h
      mei: include local headers after the system ones
      mei: kill not used BAR0 length and base variables
      mei: mei_me_client is not hw API move to mei_dev.h
      mei: move hw dependent functions to interface.c
      mei: move host bus message handling to hbm.c
      mei: drop nonexistent function prototype
      mei: simplify preparing client host bus messages
      mei: use structured buffer for the write buffer
      mei: add common prefix to hbm function
      mei: move hbm responses from interrupt.c to hbm.c
      mei: add new hbm.h header to export hbm protocol
      mei: move client functions to client.c
      mei: fix client functions names
      mei: implement mei_cl_connect function
      mei: move watchdog prototypes to mei_dev.h from interface.h
      mei: rename interface to hw-me
      mei: drop read_pending member form struct mei_cl
      mei: move me client storage allocation to hbm.c
      mei: mei_dev.h - remove prototypes of dropped functions
      mei: rename remaining amthi strings to amthif
      mei: normalize me host client linking routines
      mei: move MEI_IAMTHIF_IDLE to amthif host init function
      mei: hw-me.c fix kernel doc
      mei: remove write only need_reset member of struct mei_device
      mei: remove mei_csr_clear_his prototype
      mei: don't use cached value for hcsr in mei_hw_reset
      mei: use non cached hcsr for interrupt enablement
      mei: abstract host and device readieness
      mei: reenable mei_hcsr_set abstraction
      mei: make host csr and me csr internal to hw-me
      mei: move work initialization to mei_device_init
      mei: drop the warning when cl is not initialized during unlinking
      mei: sperate interface and pci code into two files
      mei: initial extract of ME hw specifics from mei_device
      mei: separate compilation of the ME hardware specifics
      mei: move interrupt handlers to be me hw specific
      mei: rename to mei_host_buffer_is_empty to hbuf_is_ready
      mei: move clients cleanup code from init.c to client.c
      mei: fix undefined wd symbols when MEI_ME is not set

Wei Yongjun (2):
      hv: hv_balloon: remove duplicated include from hv_balloon.c
      Drivers: hv: remove unused variable in vmbus_recvpacket_raw()

channing (1):
      misc: st_core: Error triggered by convert "char" to "int"

 CREDITS                                            |    8 +-
 Documentation/DocBook/uio-howto.tmpl               |    2 +-
 Documentation/w1/slaves/w1_therm                   |   13 +-
 MAINTAINERS                                        |    7 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/char/hw_random/exynos-rng.c                |    2 +-
 drivers/char/mem.c                                 |   10 +-
 drivers/char/pcmcia/synclink_cs.c                  |  649 ++--
 drivers/extcon/Kconfig                             |    4 +-
 drivers/extcon/extcon-arizona.c                    |  810 ++++-
 drivers/extcon/extcon-gpio.c                       |    2 +-
 drivers/extcon/extcon-max77693.c                   |  981 ++++--
 drivers/extcon/extcon-max8997.c                    |  734 +++--
 drivers/hid/hid-hyperv.c                           |    3 +-
 drivers/hv/channel.c                               |   33 +-
 drivers/hv/channel_mgmt.c                          |   93 +
 drivers/hv/connection.c                            |  232 +-
 drivers/hv/hv.c                                    |   72 +-
 drivers/hv/hv_balloon.c                            |   63 +-
 drivers/hv/hv_util.c                               |   46 +-
 drivers/hv/hyperv_vmbus.h                          |   65 +-
 drivers/hv/ring_buffer.c                           |  130 +-
 drivers/hv/vmbus_drv.c                             |   54 +-
 drivers/ipack/devices/ipoctal.c                    |  114 +-
 drivers/mfd/wm5102-tables.c                        |   10 +
 drivers/misc/Kconfig                               |   12 +
 drivers/misc/Makefile                              |    3 +
 drivers/misc/cb710/Kconfig                         |    2 +-
 drivers/misc/lattice-ecp3-config.c                 |  243 ++
 drivers/misc/mei/Kconfig                           |   15 +-
 drivers/misc/mei/Makefile                          |    6 +-
 drivers/misc/mei/amthif.c                          |  164 +-
 drivers/misc/mei/client.c                          |  729 +++++
 drivers/misc/mei/client.h                          |  102 +
 drivers/misc/mei/hbm.c                             |  669 ++++
 drivers/misc/mei/hbm.h                             |   39 +
 drivers/misc/mei/hw-me-regs.h                      |  167 +
 drivers/misc/mei/hw-me.c                           |  576 ++++
 drivers/misc/mei/hw-me.h                           |   48 +
 drivers/misc/mei/hw.h                              |  125 +-
 drivers/misc/mei/init.c                            |  572 +---
 drivers/misc/mei/interface.c                       |  388 ---
 drivers/misc/mei/interface.h                       |   81 -
 drivers/misc/mei/interrupt.c                       |  656 +---
 drivers/misc/mei/iorw.c                            |  366 ---
 drivers/misc/mei/main.c                            |  536 +--
 drivers/misc/mei/mei_dev.h                         |  350 +-
 drivers/misc/mei/pci-me.c                          |  396 +++
 drivers/misc/mei/wd.c                              |   77 +-
 drivers/misc/ti-st/st_core.c                       |    3 +-
 drivers/misc/vmw_vmci/Kconfig                      |   16 +
 drivers/misc/vmw_vmci/Makefile                     |    4 +
 drivers/misc/vmw_vmci/vmci_context.c               | 1214 +++++++
 drivers/misc/vmw_vmci/vmci_context.h               |  182 ++
 drivers/misc/vmw_vmci/vmci_datagram.c              |  500 +++
 drivers/misc/vmw_vmci/vmci_datagram.h              |   52 +
 drivers/misc/vmw_vmci/vmci_doorbell.c              |  604 ++++
 drivers/misc/vmw_vmci/vmci_doorbell.h              |   51 +
 drivers/misc/vmw_vmci/vmci_driver.c                |  117 +
 drivers/misc/vmw_vmci/vmci_driver.h                |   50 +
 drivers/misc/vmw_vmci/vmci_event.c                 |  224 ++
 drivers/misc/vmw_vmci/vmci_event.h                 |   25 +
 drivers/misc/vmw_vmci/vmci_guest.c                 |  759 +++++
 drivers/misc/vmw_vmci/vmci_handle_array.c          |  142 +
 drivers/misc/vmw_vmci/vmci_handle_array.h          |   52 +
 drivers/misc/vmw_vmci/vmci_host.c                  | 1043 ++++++
 drivers/misc/vmw_vmci/vmci_queue_pair.c            | 3425 ++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_queue_pair.h            |  191 ++
 drivers/misc/vmw_vmci/vmci_resource.c              |  229 ++
 drivers/misc/vmw_vmci/vmci_resource.h              |   59 +
 drivers/misc/vmw_vmci/vmci_route.c                 |  226 ++
 drivers/misc/vmw_vmci/vmci_route.h                 |   30 +
 drivers/mmc/host/Kconfig                           |    2 +-
 drivers/net/Kconfig                                |    4 +
 drivers/net/Makefile                               |    1 +
 drivers/net/hyperv/netvsc_drv.c                    |    3 +-
 drivers/net/ntb_netdev.c                           |  408 +++
 drivers/ntb/Kconfig                                |   13 +
 drivers/ntb/Makefile                               |    3 +
 drivers/ntb/ntb_hw.c                               | 1141 +++++++
 drivers/ntb/ntb_hw.h                               |  181 ++
 drivers/ntb/ntb_regs.h                             |  139 +
 drivers/ntb/ntb_transport.c                        | 1441 ++++++++
 drivers/pcmcia/i82092.c                            |    8 +-
 drivers/pcmcia/vrc4171_card.c                      |    1 +
 drivers/scsi/storvsc_drv.c                         |   12 +-
 drivers/vme/vme.c                                  |    1 +
 drivers/w1/masters/ds1wm.c                         |   52 +-
 drivers/w1/masters/ds2482.c                        |   51 +-
 drivers/w1/masters/mxc_w1.c                        |   49 +-
 drivers/w1/masters/w1-gpio.c                       |    2 +-
 drivers/w1/slaves/w1_therm.c                       |   36 +-
 .../linux/extcon/{extcon_gpio.h => extcon-gpio.h}  |    0
 include/linux/hyperv.h                             |  248 +-
 include/linux/mfd/arizona/core.h                   |    4 +-
 include/linux/mfd/arizona/pdata.h                  |   21 +
 include/linux/mfd/arizona/registers.h              |   56 +
 include/linux/mfd/max77693-private.h               |   86 +
 include/linux/mfd/max77693.h                       |    9 +
 include/linux/mfd/max8997-private.h                |   64 +
 include/linux/mfd/max8997.h                        |   25 +-
 include/linux/ntb.h                                |   83 +
 include/linux/vmw_vmci_api.h                       |   82 +
 include/linux/vmw_vmci_defs.h                      |  880 +++++
 tools/hv/hv_kvp_daemon.c                           |   79 +-
 tools/hv/hv_set_ifconfig.sh                        |   24 +-
 107 files changed, 20752 insertions(+), 4117 deletions(-)
 create mode 100644 drivers/misc/lattice-ecp3-config.c
 create mode 100644 drivers/misc/mei/client.c
 create mode 100644 drivers/misc/mei/client.h
 create mode 100644 drivers/misc/mei/hbm.c
 create mode 100644 drivers/misc/mei/hbm.h
 create mode 100644 drivers/misc/mei/hw-me-regs.h
 create mode 100644 drivers/misc/mei/hw-me.c
 create mode 100644 drivers/misc/mei/hw-me.h
 delete mode 100644 drivers/misc/mei/interface.c
 delete mode 100644 drivers/misc/mei/interface.h
 delete mode 100644 drivers/misc/mei/iorw.c
 create mode 100644 drivers/misc/mei/pci-me.c
 create mode 100644 drivers/misc/vmw_vmci/Kconfig
 create mode 100644 drivers/misc/vmw_vmci/Makefile
 create mode 100644 drivers/misc/vmw_vmci/vmci_context.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_context.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_datagram.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_datagram.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_doorbell.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_doorbell.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_driver.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_driver.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_event.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_event.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_guest.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_host.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_queue_pair.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_queue_pair.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_resource.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_resource.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_route.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_route.h
 create mode 100644 drivers/net/ntb_netdev.c
 create mode 100644 drivers/ntb/Kconfig
 create mode 100644 drivers/ntb/Makefile
 create mode 100644 drivers/ntb/ntb_hw.c
 create mode 100644 drivers/ntb/ntb_hw.h
 create mode 100644 drivers/ntb/ntb_regs.h
 create mode 100644 drivers/ntb/ntb_transport.c
 rename include/linux/extcon/{extcon_gpio.h => extcon-gpio.h} (100%)
 create mode 100644 include/linux/ntb.h
 create mode 100644 include/linux/vmw_vmci_api.h
 create mode 100644 include/linux/vmw_vmci_defs.h
