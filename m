Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab3A1E4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:56:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:44232 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab3A1E4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:56:52 -0500
Date: Sun, 27 Jan 2013 20:58:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.28
Message-ID: <20130128045836.GA3552@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.28 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                   |    2=20
 drivers/acpi/processor_idle.c              |    4 +
 drivers/ata/ahci.c                         |   13 ++++
 drivers/dma/ioat/dma_v3.c                  |    2=20
 drivers/firmware/dmi_scan.c                |   78 ++++++++++++++++++++++--=
-----
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   21 +++++++
 drivers/gpu/drm/i915/i915_reg.h            |    3 +
 drivers/gpu/drm/i915/intel_display.c       |    4 +
 drivers/pci/hotplug/pciehp.h               |    2=20
 drivers/pci/hotplug/pciehp_core.c          |   11 ----
 drivers/pci/hotplug/pciehp_ctrl.c          |    8 +-
 drivers/pci/hotplug/pciehp_hpc.c           |   11 +++-
 drivers/pci/hotplug/shpchp.h               |    1=20
 drivers/pci/hotplug/shpchp_core.c          |   10 ---
 drivers/pci/hotplug/shpchp_ctrl.c          |    2=20
 drivers/pci/pcie/aer/aerdrv_core.c         |    1=20
 drivers/pci/pcie/aspm.c                    |    3 +
 drivers/scsi/sd.c                          |   13 ++--
 drivers/usb/dwc3/gadget.c                  |    1=20
 drivers/usb/host/uhci-hcd.c                |   15 +++--
 include/linux/sched.h                      |   11 +++-
 kernel/ptrace.c                            |   72 +++++++++++++++++++++---=
--
 kernel/sched/core.c                        |    3 -
 kernel/signal.c                            |   19 +++----
 kernel/trace/ftrace.c                      |    2=20
 security/integrity/evm/evm_crypto.c        |    4 -
 sound/usb/endpoint.c                       |    6 --
 27 files changed, 230 insertions(+), 92 deletions(-)

Alan Cox (1):
      ahci: Add identifiers for ASM106x devices

Alan Stern (1):
      USB: UHCI: fix IRQ race during initialization

Betty Dall (1):
      PCI/AER: pci_get_domain_bus_and_slot() call missing required pci_dev_=
put()

Bjorn Helgaas (1):
      PCI: shpchp: Handle push button event asynchronously

Chris Wilson (1):
      drm/i915: Invalidate the relocation presumed_offsets along the slow p=
ath

Colin Ian King (1):
      PCI: Allow pcie_aspm=3Dforce even when FADT indicates it is unsupport=
ed

Daniel Vetter (1):
      drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled

Dmitry Kasatkin (1):
      evm: checking if removexattr is not a NULL

Greg Kroah-Hartman (1):
      Linux 3.4.28

Hugh Daschbach (1):
      libata: ahci: Add support for Enmotus Bobcat device.

Joel D. Diaz (1):
      SCSI: sd: Reshuffle init_sd to avoid crash

Konrad Rzeszutek Wilk (1):
      ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled

Oleg Nesterov (3):
      ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()
      ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
      wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACE=
D task

Pratyush Anand (1):
      usb: dwc3: gadget: fix ep->maxburst for ep0

Shuah Khan (1):
      ioat: Fix DMA memory sync direction correct flag

Steven Rostedt (1):
      ftrace: Be first to run code modification on modules

Takashi Iwai (1):
      ALSA: usb-audio: Fix regression by disconnection-race-fix patch

Thomas Schlichter (1):
      ACPI / processor: Get power info before updating the C-states

Yijing Wang (1):
      PCI: pciehp: Use per-slot workqueues to avoid deadlock

Zhenzhong Duan (2):
      drivers/firmware/dmi_scan.c: check dmi version when get system uuid
      drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exis=
ts


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRBgV8AAoJEDjbvchgkmk+ktAQAJC5W1hhnD28jgKMjI0f7GPM
RkM8pxTyon/XbxxjXd3X730s9keYzbY7P9h+s/0StHROdFYw8XFJtxgf/bJAS3Q+
FyDDlAvUIbkm5lu2yycJPESRvGgPDVeHlFzNjV0dlbdDSvTROwtQDlWZcxbqZ7iz
TeBb9/RIu5OfKp70eWSXvvizcnXMCiC1btvEVddDCScx5W+s8z3hfBDZzlgOC3lN
qbDPog4zq11eVtw04aYkxc793UEGO/5/mTmRW5t8vjFUq9cbNo1maj+Iwed7yURq
/4V9qwDOQ3HC0haAPq+r/rJgLtNQ3O3pBtW9UPVf97fobLZPuvTFmgYh/vmrWbc7
HEoCNfvGrq8g3Lz16KKT8c9EL/v9Ut2Xx2MJR6y41PpEdBsx8AkXbjURMTsw0224
157uuT/zpGenLdT/5WiXxAPFZAn1j2yjBx9FKumeUPhNX995frshrSRvpEQF2+Xa
9Y1ibXgCGueyCIZIuIThcalTbONASMXZweMlJBGrjTVsHckkrq3DSfjf+E0HELg9
zyCsy5wHq/yjp+yMoDaN+nhwCcs/sK2bupCUrs5mpLNrt+e5AKl3Yb53PrCufZDR
uEaZB2aswi6gy3wJUppcKoKWSn7AilY68322+nlbj8cdSEzzaV+l4iSdqC80zvbR
ELwuBd2Kx85C5IPL1my5
=9w8+
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
