Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbaEFPlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:41:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818AbaEFPlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:41:11 -0400
Date: Tue, 6 May 2014 08:41:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.89
Message-ID: <20140506154110.GA13527@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.89 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/arm/include/asm/div64.h                 |    2=20
 arch/arm/kernel/machine_kexec.c              |    7 ++
 arch/arm/mach-omap2/irq.c                    |    8 ++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |    4 -
 arch/sh/kernel/dumpstack.c                   |    2=20
 arch/x86/kernel/ldt.c                        |   11 +++
 drivers/infiniband/hw/ehca/ehca_cq.c         |    1=20
 drivers/infiniband/hw/ipath/ipath_diag.c     |   66 +++++++-----------
 drivers/infiniband/hw/mthca/mthca_provider.c |    1=20
 drivers/infiniband/hw/nes/nes_verbs.c        |    2=20
 drivers/infiniband/ulp/srpt/ib_srpt.c        |   16 ++--
 drivers/mfd/max8925-i2c.c                    |    9 ++
 drivers/mfd/max8997.c                        |   18 +++++
 drivers/mfd/max8998.c                        |    4 +
 drivers/scsi/arcmsr/arcmsr_hba.c             |    7 --
 drivers/staging/rtl8712/rtl871x_recv.c       |   13 +--
 drivers/staging/serqt_usb2/serqt_usb2.c      |    2=20
 drivers/target/iscsi/iscsi_target.c          |    4 -
 drivers/target/tcm_fc/tfc_sess.c             |    1=20
 drivers/tty/hvc/hvc_console.c                |    6 +
 drivers/usb/core/driver.c                    |   94 ++++++++++++++++------=
-----
 drivers/usb/core/hcd-pci.c                   |    2=20
 drivers/usb/core/hub.c                       |    5 -
 drivers/usb/core/usb.h                       |    2=20
 drivers/usb/dwc3/core.h                      |    6 -
 drivers/usb/host/xhci-pci.c                  |    4 -
 drivers/usb/host/xhci.c                      |    6 -
 drivers/usb/musb/musb_gadget.c               |   22 +++++-
 drivers/usb/serial/pl2303.c                  |    3=20
 drivers/usb/serial/pl2303.h                  |    5 +
 drivers/w1/w1_netlink.c                      |   25 +++----
 fs/ext4/file.c                               |    2=20
 fs/nfsd/nfs4proc.c                           |    9 ++
 fs/nfsd/nfs4xdr.c                            |    5 +
 fs/nfsd/vfs.c                                |    9 ++
 fs/ocfs2/buffer_head_io.c                    |    2=20
 fs/ocfs2/dlm/dlmrecovery.c                   |   29 ++++++--
 fs/reiserfs/dir.c                            |    6 +
 kernel/sysctl.c                              |    6 +
 mm/hugetlb.c                                 |    1=20
 sound/pci/hda/patch_realtek.c                |    1=20
 sound/pci/ice1712/ice1712.c                  |   15 ++--
 sound/soc/codecs/cs42l73.c                   |    6 -
 44 files changed, 295 insertions(+), 156 deletions(-)

Aaron Sanders (1):
      USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Alan Stern (2):
      USB: fix crash during hotplug of PCI USB controller card
      USB: unbind all interfaces before rebinding any

Andy Grover (1):
      target/tcm_fc: Fix use-after-free of ft_tpg

Brian Austin (1):
      ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE

Dan Carpenter (1):
      SCSI: arcmsr: upper 32 of dma address lost

David Cohen (1):
      usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM

David Fries (1):
      w1: fix w1_send_slave dropping a slave id

Dennis Dalessandro (1):
      IB/ipath: Fix potential buffer overrun in sending diag packet routine

Greg Kroah-Hartman (1):
      Linux 3.4.89

H. Peter Anvin (1):
      x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

Himangi Saraogi (1):
      staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to =
integer

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_devt

Igor Gnatenko (1):
      xhci: extend quirk for Renesas cards

J. Bruce Fields (5):
      nfsd4: session needs room for following op to error out
      nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
      nfsd4: fix test_stateid error reply encoding
      nfsd: notify_change needs elevated write count
      nfsd4: fix setclientid encode size

Jeff Mahoney (1):
      reiserfs: fix race in readdir

Junxiao Bi (2):
      ocfs2: dlm: fix lock migration crash
      ocfs2: dlm: fix recovery hung

Krzysztof Kozlowski (3):
      mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy =
error
      mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy =
error
      mfd: max8997: Fix possible NULL pointer dereference on i2c_new_dummy =
error

Larry Finger (1):
      staging: r8712u: Fix case where ethtype was never obtained and always=
 be checked against 0

Liu Hua (2):
      ARM: 8030/1: ARM : kdump : add arch_crash_save_vmcoreinfo
      hung_task: check the value of "sysctl_hung_task_timeout_sec"

Matt Fleming (1):
      sh: fix format string bug in stack tracer

Mike Marciniszyn (1):
      ib_srpt: Use correct ib_sg_dma primitives

Mizuma, Masayoshi (1):
      mm: hugetlb: fix softlockup when a large number of hugepages are free=
d.

Nicholas Bellinger (1):
      iscsi-target: Fix ERL=3D2 ASYNC_EVENT connection pointer bug

Paul Gortmaker (1):
      hvc: ensure hvc_init is only ever called once in hvc_console.c

Roger Quadros (1):
      ARM: OMAP3: hwmod data: Correct clock domains for USB modules

Stefan S=F8rensen (1):
      ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Takashi Iwai (1):
      ALSA: ice1712: Fix boundary checks in PCM pointer ops

Theodore Ts'o (1):
      ext4: use i_size_read in ext4_unaligned_aio()

W. Trevor King (1):
      ALSA: hda - Enable beep for ASUS 1015E

Xiangyu Lu (1):
      ARM: 8027/1: fix do_div() bug in big-endian systems

Yann Droneaud (3):
      IB/nes: Return an error on ib_copy_from_udata() failure instead of NU=
LL
      IB/mthca: Return an error on ib_copy_to_udata() failure
      IB/ehca: Returns an error on ib_copy_to_udata() failure

alex chen (1):
      ocfs2: do not put bh when buffer_uptodate failed

supriya karanth (1):
      usb: musb: set TXMAXP and AUTOSET for full speed bulk in device mode


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTaQKWAAoJEDjbvchgkmk+ZTEQANDenZDHlpGN9mDFi9zVdA6A
+Jg8vRbSPPsELoI827KHl94H11drwo6SZ8IzliSynq2VugJLcT+nxj3kSGXFMA34
HCOUqychCfUq2sqQCjIQXS5ivLTY2q8OBD2q4D2EPdKHTD/rrbWbqHC0xCGDpfqi
wXfgWOAuB0PeHSyxYhfJaZrM0+KJcfl3OxCjOD8k57+dHbE9hEQrpIvosFWmRU5i
MT+gf0EH3DKHRit3ojt1pahqs1jqSlZnKXwRgBWyVmS88rspJ/D1ndvSbBMxy2Zc
iRP5tMGhpDsSbixkKSNH/+IOxNHABjDTA6T+R1d1lMVmMcWJ+tKnB4RPRJeOpcPS
OwYzjkjXVKxjFleNkhvKAfwfEQb7mkIiJCSnVT0XdtbZNZIq5WuVldQijZcRan3K
0h86a8zJoC6IRBkcUwC1gvzM3/nLJp4roGwNuRy4t8BQAIASF9rlw3cxhZb23Lwg
MShmDNUG2icIXOP7anIXtJuwQ+ko8oqm2plVRzT/qRdcKFvpzKBW+6R+eQkvTbeN
IUFmN5CSTfyTf2GqWjDuJmxEbz4Pd4EgtqR8ilib9xtuqqIeNER9ciRa+C38S32x
Yr+mNSGz0iccv6QIE/AftVbza6luXZz+zIcBLr+y5tmF/AJoXfU4ncOYLOFBoy73
XVYrE3RXOj5PCxyd4uMt
=Egwu
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
