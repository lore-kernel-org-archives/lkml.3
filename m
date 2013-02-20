Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935865Ab3BTEVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:21:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38852 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933066Ab3BTEVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:21:03 -0500
Message-ID: <1361334049.29126.28.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.39
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 20 Feb 2013 04:20:49 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-dLLbrhvQtRHIe91eQcbo"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dLLbrhvQtRHIe91eQcbo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.39 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 MAINTAINERS                                        |    6 +-
 Makefile                                           |    2 +-
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
 drivers/usb/storage/unusual_devs.h                 |  329 +---------------=
----
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
 65 files changed, 649 insertions(+), 605 deletions(-)

Alan Stern (2):
      USB: XHCI: fix memory leak of URB-private data
      USB: EHCI: fix bug in scheduling periodic split transfers

Alessandro Rubini (1):
      ahci: support the STA2X11 I/O Hub

Alex Deucher (2):
      drm/radeon: add quirk for RV100 board
      drm/radeon: prevent crash in the ring space allocation

Alexander Stein (1):
      can: c_can: Set reserved bit in IFx_MASK2 to 1 on write

Ben Hutchings (2):
      drm/i915: Fix misplaced intel_mark_page_flip_active()
      Linux 3.2.39

Bing Zhao (1):
      mwifiex: fix incomplete scan in case of IE parsing error

Bj=C3=B8rn Mork (1):
      USB: option: add Changhong CH690

Cong Wang (2):
      net: prevent setting ttl=3D0 via IP_TTL
      pktgen: correctly handle failures when adding a device

Daniel Borkmann (2):
      net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
      net: sctp: sctp_endpoint_free: zero out secret key data

Daniele Palmas (2):
      USB: qcserial: add Telit Gobi QDL device
      USB: option: add support for Telit LE920

David Moore (1):
      usb: Prevent dead ports when xhci is not enabled

Eric Dumazet (4):
      netxen: fix off by one bug in netxen_release_tx_buffer()
      net: loopback: fix a dst refcounting issue
      tcp: frto should not set snd_cwnd to 0
      tcp: fix MSG_SENDPAGE_NOTLAST logic

Haojian Zhuang (1):
      drivers/rtc/rtc-pl031.c: fix the missing operation on enable

Heiko Carstens (1):
      atm/iphase: rename fregt_t -> ffreg_t

Hugh Daschbach (1):
      ahci: Add support for Enmotus Bobcat device.

Ian Campbell (3):
      xen/netback: shutdown the ring if it contains garbage.
      xen/netback: free already allocated memory on failure in xen_netbk_ge=
t_requests
      netback: correct netbk_tx_err to handle wrap around.

Ilpo J=C3=A4rvinen (1):
      tcp: fix for zero packets_in_flight was too broad

Jacob Schloss (1):
      gspca_kinect: add Kinect for Windows USB id

Jan Beulich (2):
      x86-64: Replace left over sti/cli in ia32 audit exit code
      x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

Jan Luebbe (1):
      drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq h=
andler

Jaume Delcl=C3=B2s (1):
      Wireless: rt2x00: Add device id for Sweex LW323 to rt2800usb.c

Johan Hedberg (1):
      Bluetooth: Fix handling of unexpected SMP PDUs

Larry Finger (1):
      rtlwifi: Fix the usage of the wrong variable in usb.c

Maia Kozheva (1):
      rt2800usb: Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB Wi-F=
i adapter

Marcelo Ricardo Leitner (1):
      ipv6: do not create neighbor entries for local delivery

Matthew Daley (1):
      xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.

Neil Horman (1):
      sctp: refactor sctp_outq_teardown to insure proper re-initalization

Nicholas Santos (1):
      HID: usbhid: quirk for Formosa IR receiver

Nithin Nayak Sujir (2):
      tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mo=
de
      tg3: Fix crc errors on jumbo frame receive

Oleg Nesterov (5):
      ptrace/x86: Introduce set_task_blockstep() helper
      ptrace/x86: Partly fix set_task_blockstep()->update_debugctlmsr() log=
ic
      ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()
      ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
      wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACE=
D task

Petr Kub=C3=A1nek (1):
      USB: ftdi_sio: add Zolix FTDI PID

Phil Sutter (1):
      packet: fix leakage of tx_ring memory

Romain KUNTZ (1):
      ipv6: fix header length calculation in ip6_append_data()

Romain Kuntz (1):
      ipv6: fix the noflags test in addrconf_get_prefix_route

Sarah Sharp (2):
      xhci: Fix isoc TD encoding.
      xhci: Fix TD size for isochronous URBs.

Sarveshwar Bandi (1):
      bridge: Pull ip header into skb->data before looking into ip header.

Shawn Bohrer (1):
      sched/rt: Use root_domain of rt_rq not current processor

Sjur Br=C3=A6ndeland (1):
      virtio_console: Don't access uninitialized data.

Stephen Hemminger (1):
      MAINTAINERS: Stephen Hemminger email change

Sven Killig (1):
      USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II

Szymon Janc (1):
      Bluetooth: Fix sending HCI commands after reset

T Makphaibulchoke (1):
      kernel/resource.c: fix stack overflow in __reserve_region_with_split(=
)

Tilman Schmidt (1):
      isdn/gigaset: fix zero size border case in debug dump

Timo Ter=C3=A4s (1):
      r8169: remove the obsolete and incorrect AMD workaround

Vyacheslav Dubeyko (1):
      nilfs2: fix fix very long mount time issue

Xose Vazquez Perez (1):
      wireless: rt2x00: rt{2500,73}usb.c put back duplicate id

fangxiaozhi (2):
      USB: storage: Define a new macro for USB storage match rules
      USB: storage: optimize to match the Huawei USB storage devices and su=
pport new switch command

liu chuansheng (1):
      drm/radeon: Calling object_unrefer() when creating fb failure



--=-dLLbrhvQtRHIe91eQcbo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUSRPIee/yOyVhhEJAQrCdw//WefnF4iae5YTVsW1miw4641Xg4YFVEiL
OAV9jtPOw4zLHWmxwQwenjkhViKP16ExVNxRK1wjTN13953aTRshvYpRUCg1el4s
i4L/IrJRbjiG5eTE6eOXPNyQz+q8JtdN15IBY9/toV3DeJrlyHpkF7d7pQljQArv
LRrDlDhXCCl4u3N+Y9eDn/j11fp005jnNNdsE8FqBYezOCGLY+WSSgSYpsW1D8bi
3QgYV4dgGF/G4BPu//L8subCmSTjvWecgxID62T/GkEuDUQOZ1HgILOWag9soznv
uJOj6AjKWXhWG39xLj8E2Wo5bMmsJ540vmaZKc6ie59EG5kQwb9+L+dE2rpuy9oo
kw4InlwSnKs8jUHbsrC4aRBzQioZqKYNfC/Bcwy7/KUkxzgp/ztWp59ePnEuPm8g
yaYP32u7+WLvuFdv8bxgXts7pzKL/VKvWfjx90sVbin/8gsHlluKWQDX01dGY9Xk
HJn6L0aYvjO7jDsslBhkCbcSMvfql5VrJLayIXBMl47KUUL5V9eggDOhS/gS3C6V
0rTjVMIVDwta84w3xS1qEhORdcxbi5Yo7y2D+YDUxzL1VCwvqkw2qCB3f8pJa+yD
5ad7SY5dvs7WDDCctu+iMgXcZxmU6C0elwK1+EBsvKPMZMaMRy2OXO/t74Cw2Tjj
n2RrBRZ65Kk=
=NRDF
-----END PGP SIGNATURE-----

--=-dLLbrhvQtRHIe91eQcbo--
