Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab3BQWzD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45573 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635Ab3BQWyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:54:54 -0500
Message-Id: <20130217225001.621306883@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:01 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [ 00/66] 3.2.39-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.39 release.
There are 66 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Feb 19 23:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.38 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Alan Stern (2):
      USB: EHCI: fix bug in scheduling periodic split transfers
         [3e619d04159be54b3daa0b7036b0ce9e067f4b5d]
      USB: XHCI: fix memory leak of URB-private data
         [48c3375c5f69b1c2ef3d1051a0009cb9bce0ce24]

Alessandro Rubini (1):
      ahci: support the STA2X11 I/O Hub
         [318893e1429a9d50569a0379d1e20b0ecc45c555]

Alex Deucher (2):
      drm/radeon: add quirk for RV100 board
         [9200ee4941a6e5d1ec5df88982243686882dff3f]
      drm/radeon: prevent crash in the ring space allocation
         [fd5d93a0015ce1a7db881382022b2fcdfdc61760]

Alexander Stein (1):
      can: c_can: Set reserved bit in IFx_MASK2 to 1 on write
         [2bd3bc4e8472424f1a6009825397639a8968920a]

Ben Hutchings (1):
      drm/i915: Fix misplaced intel_mark_page_flip_active()
         [not needed upstream; fixes bug introduced in backporting
          e7d841ca03b7ab668620045cd7b428eda9f41601]

Bing Zhao (1):
      mwifiex: fix incomplete scan in case of IE parsing error
         [8a7d7cbf7b5ff9912ef50b3e94c9ad9f37b1c75f]

Bjørn Mork (1):
      USB: option: add Changhong CH690
         [d4fa681541aa7bf8570d03426dd7ba663a71c467]

Cong Wang (2):
      net: prevent setting ttl=0 via IP_TTL
         [c9be4a5c49cf51cc70a993f004c5bb30067a65ce]
      pktgen: correctly handle failures when adding a device
         [604dfd6efc9b79bce432f2394791708d8e8f6efc]

Daniel Borkmann (2):
      net: sctp: sctp_endpoint_free: zero out secret key  data
         [b5c37fe6e24eec194bb29d22fdd55d73bcc709bf]
      net: sctp: sctp_setsockopt_auth_key: use kzfree  instead of kfree
         [6ba542a291a5e558603ac51cda9bded347ce7627]

Daniele Palmas (2):
      USB: option: add support for Telit LE920
         [03eb466f276ceef9dcf023dc5474db02af68aad9]
      USB: qcserial: add Telit Gobi QDL device
         [78796ae17eacedcdcaaeb03ba73d2e532a4c8f83]

David Moore (1):
      usb: Prevent dead ports when xhci is not enabled
         [58b2939b4d5a030eaec469d29812ab8477ee7e76]

Eric Dumazet (4):
      net: loopback: fix a dst refcounting issue
         [794ed393b707f01858f5ebe2ae5eabaf89d00022]
      netxen: fix off by one bug in  netxen_release_tx_buffer()
         [a05948f296ce103989b28a2606e47d2e287c3c89]
      tcp: fix MSG_SENDPAGE_NOTLAST logic
         [ae62ca7b03217be5e74759dc6d7698c95df498b3]
      tcp: frto should not set snd_cwnd to 0
         [2e5f421211ff76c17130b4597bc06df4eeead24f]

Fangxiaozhi (2):
      USB: storage: Define a new macro for USB storage match rules
         [07c7be3d87e5cdaf5f94c271c516456364ef286c]
      USB: storage: optimize to match the Huawei USB storage devices and support new switch command
         [200e0d994d9d1919b28c87f1a5fb99a8e13b8a0f]

Haojian Zhuang (1):
      drivers/rtc/rtc-pl031.c: fix the missing operation on enable
         [e7e034e18a0ab6bafb2425c3242cac311164f4d6]

Heiko Carstens (1):
      atm/iphase: rename fregt_t -> ffreg_t
         [ab54ee80aa7585f9666ff4dd665441d7ce41f1e8]

Hugh Daschbach (1):
      [libata] ahci: Add support for Enmotus Bobcat device.
         [7f9c9f8e24590e7dcd26ca408458c43df5b83e61]

Ian Campbell (3):
      netback: correct netbk_tx_err to handle wrap around.
         [b9149729ebdcfce63f853aa54a404c6a8f6ebbf3]
      xen/netback: free already allocated memory on failure  in xen_netbk_get_requests
         [4cc7c1cb7b11b6f3515bd9075527576a1eecc4aa]
      xen/netback: shutdown the ring if it contains garbage.
         [48856286b64e4b66ec62b94e504d0b29c1ade664]

Ilpo Järvinen (1):
      tcp: fix for zero packets_in_flight was too broad
         [6731d2095bd4aef18027c72ef845ab1087c3ba63]

Jacob Schloss (1):
      [media] gspca_kinect: add Kinect for Windows USB id
         [98fd485795db064d0885150e2c0c7f296d8fe06e]

Jan Beulich (2):
      x86-64: Replace left over sti/cli in ia32 audit exit code
         [40a1ef95da85843696fc3ebe5fce39b0db32669f]
      x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.
         [13d2b4d11d69a92574a55bfd985cfb0ca77aebdc]

Jan Luebbe (1):
      drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq handler
         [72fca4a4b32dc778b5b885c3498700e42b610d49]

Jaume Delclòs (1):
      Wireless: rt2x00: Add device id for Sweex LW323 to rt2800usb.c
         [36f318bb124b231c01db6965a009f46d5731f012]

Johan Hedberg (1):
      Bluetooth: Fix handling of unexpected SMP PDUs
         [8cf9fa1240229cbdd888236c0c43fcbad680cf00]

Larry Finger (1):
      rtlwifi: Fix the usage of the wrong variable in usb.c
         [0a06ad8e3a1cb5311b7dbafde45410aa1bce9d40]

Liu Chuansheng (1):
      drm/radeon: Calling object_unrefer() when creating fb failure
         [f2d68cf4daa4de97d400d94836b907e35228e54f]

Maia Kozheva (1):
      rt2800usb: Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB Wi-Fi adapter
         [fd7b9270120ca7e53fbf0469febe0c68acf6a0a2]

Marcelo Ricardo Leitner (1):
      ipv6: do not create neighbor entries for local  delivery
         [bd30e947207e2ea0ff2c08f5b4a03025ddce48d3]

Matthew Daley (1):
      xen/netback: don't leak pages on failure in  xen_netbk_tx_check_gop.
         [7d5145d8eb2b9791533ffe4dc003b129b9696c48]

Neil Horman (1):
      sctp: refactor sctp_outq_teardown to insure proper  re-initalization
         [2f94aabd9f6c925d77aecb3ff020f1cc12ed8f86]

Nicholas Santos (1):
      HID: usbhid: quirk for Formosa IR receiver
         [320cde19a4e8f122b19d2df7a5c00636e11ca3fb]

Nithin Nayak Sujir (2):
      tg3: Avoid null pointer dereference in tg3_interrupt  in netconsole mode
         [9c13cb8bb477a83b9a3c9e5a5478a4e21294a760]
      tg3: Fix crc errors on jumbo frame receive
         [daf3ec688e057f6060fb9bb0819feac7a8bbf45c]

Oleg Nesterov (5):
      ptrace/x86: Introduce set_task_blockstep() helper
         [848e8f5f0ad3169560c516fff6471be65f76e69f]
      ptrace/x86: Partly fix set_task_blockstep()->update_debugctlmsr() logic
         [95cf00fa5d5e2a200a2c044c84bde8389a237e02]
      ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
         [9899d11f654474d2d54ea52ceaa2a1f4db3abd68]
      ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()
         [910ffdb18a6408e14febbb6e4b6840fd2c928c82]
      wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACED task
         [9067ac85d533651b98c2ff903182a20cbb361fcb]

Petr Kubánek (1):
      USB: ftdi_sio: add Zolix FTDI PID
         [0ba3b2ccc72b3df5c305d61f59d93ab0f0e87991]

Phil Sutter (1):
      packet: fix leakage of tx_ring memory
         [9665d5d62487e8e7b1f546c00e11107155384b9a]

Romain KUNTZ (1):
      ipv6: fix header length calculation in  ip6_append_data()
         [7efdba5bd9a2f3e2059beeb45c9fa55eefe1bced]

Romain Kuntz (1):
      ipv6: fix the noflags test in  addrconf_get_prefix_route
         [85da53bf1c336bb07ac038fb951403ab0478d2c5]

Sarah Sharp (2):
      xhci: Fix TD size for isochronous URBs.
         [f18f8ed2a9adc41c2d9294b85b6af115829d2af1]
      xhci: Fix isoc TD encoding.
         [760973d2a74b93eb1697981f7448f0e62767cfc4]

Sarveshwar Bandi (1):
      bridge: Pull ip header into skb->data before looking  into ip header.
         [6caab7b0544e83e6c160b5e80f5a4a7dd69545c7]

Shawn Bohrer (1):
      sched/rt: Use root_domain of rt_rq not current processor
         [aa7f67304d1a03180f463258aa6f15a8b434e77d]

Sjur Brændeland (1):
      virtio_console: Don't access uninitialized data.
         [aded024a12b32fc1ed9a80639681daae2d07ec25]

Stephen Hemminger (1):
      MAINTAINERS: Stephen Hemminger email change
         [adbbf69d1a54abf424e91875746a610dcc80017d]

Sven Killig (1):
      USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II
         [c249f911406efcc7456cb4af79396726bf7b8c57]

Szymon Janc (1):
      Bluetooth: Fix sending HCI commands after reset
         [dbccd791a3fbbdac12c33834b73beff3984988e9]

T Makphaibulchoke (1):
      kernel/resource.c: fix stack overflow in __reserve_region_with_split()
         [4965f5667f36a95b41cda6638875bc992bd7d18b]

Tilman Schmidt (1):
      isdn/gigaset: fix zero size border case in debug dump
         [d721a1752ba544df8d7d36959038b26bc92bdf80]

Timo Teräs (1):
      r8169: remove the obsolete and incorrect AMD  workaround
         [5d0feaff230c0abfe4a112e6f09f096ed99e0b2d]

Vyacheslav Dubeyko (1):
      nilfs2: fix fix very long mount time issue
         [a9bae189542e71f91e61a4428adf6e5a7dfe8063]

Xose Vazquez Perez (1):
      wireless: rt2x00: rt{2500,73}usb.c put back duplicate id
         [8f35f787b75e9b6435ea37dabcae2d40dc72d31c]

 MAINTAINERS                                        |    6 +-
 Makefile                                           |    4 +-
 arch/x86/ia32/ia32entry.S                          |    4 +-
 arch/x86/kernel/step.c                             |   54 ++--
 arch/x86/xen/xen-asm_32.S                          |   14 +-
 drivers/ata/ahci.c                                 |   32 +-
 drivers/atm/iphase.h                               |  146 ++++-----
 drivers/char/virtio_console.c                      |    3 +-
 drivers/gpu/drm/i915/intel_display.c               |    4 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |    8 +
 drivers/gpu/drm/radeon/radeon_display.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |    3 +
 drivers/hid/hid-ids.h                              |    3 +
 drivers/hid/usbhid/hid-quirks.c                    |    1 +
 drivers/isdn/gigaset/capi.c                        |    2 +
 drivers/media/video/gspca/kinect.c                 |    1 +
 drivers/net/can/c_can/c_can.c                      |    6 +-
 drivers/net/ethernet/broadcom/tg3.c                |   62 ++--
 .../net/ethernet/qlogic/netxen/netxen_nic_init.c   |    2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    2 +
 drivers/net/ethernet/realtek/r8169.c               |    7 -
 drivers/net/loopback.c                             |    5 +
 drivers/net/wireless/mwifiex/scan.c                |    9 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |    2 +
 drivers/net/wireless/rt2x00/rt73usb.c              |    1 +
 drivers/net/wireless/rtlwifi/usb.c                 |    4 +-
 drivers/net/xen-netback/common.h                   |    3 +
 drivers/net/xen-netback/interface.c                |   23 +-
 drivers/net/xen-netback/netback.c                  |  115 ++++---
 drivers/rtc/rtc-isl1208.c                          |    3 +
 drivers/rtc/rtc-pl031.c                            |    8 +-
 drivers/usb/host/ehci-sched.c                      |    2 +-
 drivers/usb/host/pci-quirks.c                      |    1 +
 drivers/usb/host/xhci-ring.c                       |   11 +-
 drivers/usb/serial/ftdi_sio.c                      |    2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    9 +-
 drivers/usb/serial/option.c                        |   13 +
 drivers/usb/serial/qcserial.c                      |    1 +
 drivers/usb/storage/initializers.c                 |   76 ++++-
 drivers/usb/storage/initializers.h                 |    4 +-
 drivers/usb/storage/unusual_devs.h                 |  329 +-------------------
 drivers/usb/storage/usb.c                          |   12 +
 drivers/usb/storage/usual-tables.c                 |   15 +
 fs/nilfs2/ioctl.c                                  |    5 +-
 fs/splice.c                                        |    4 +-
 include/linux/sched.h                              |   11 +-
 kernel/ptrace.c                                    |   72 ++++-
 kernel/resource.c                                  |   50 ++-
 kernel/sched.c                                     |    3 +-
 kernel/sched_rt.c                                  |    2 +-
 kernel/signal.c                                    |   19 +-
 net/bluetooth/hci_event.c                          |    2 +-
 net/bluetooth/smp.c                                |   13 +
 net/bridge/br_netfilter.c                          |    3 +
 net/core/pktgen.c                                  |    9 +-
 net/ipv4/ip_sockglue.c                             |    2 +-
 net/ipv4/tcp_input.c                               |    5 +
 net/ipv6/addrconf.c                                |    2 +-
 net/ipv6/ip6_output.c                              |    4 +-
 net/ipv6/route.c                                   |    3 +-
 net/packet/af_packet.c                             |   10 +-
 net/sctp/endpointola.c                             |    5 +
 net/sctp/outqueue.c                                |   12 +-
 net/sctp/socket.c                                  |    2 +-
 65 files changed, 650 insertions(+), 606 deletions(-)

-- 
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones.

