Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaJOKho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:37:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaJOKhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:37:42 -0400
Date: Wed, 15 Oct 2014 12:36:35 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.17.1
Message-ID: <20141015103635.GA30731@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.17.1 kernel.

All users of the 3.17 kernel series must upgrade.

The updated 3.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.17.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt        |    4 ++
 Makefile                                   |    2 -
 arch/alpha/include/asm/Kbuild              |    1=20
 arch/arc/include/asm/Kbuild                |    1=20
 arch/arm/include/asm/irq_work.h            |   11 +++++++
 arch/arm/kernel/smp.c                      |    2 -
 arch/arm64/include/asm/Kbuild              |    2 -
 arch/arm64/include/asm/irq_work.h          |   11 +++++++
 arch/arm64/include/asm/smp.h               |    2 +
 arch/arm64/kernel/smp.c                    |    2 -
 arch/avr32/include/asm/Kbuild              |    1=20
 arch/blackfin/include/asm/Kbuild           |    1=20
 arch/c6x/include/asm/Kbuild                |    1=20
 arch/cris/include/asm/Kbuild               |    1=20
 arch/frv/include/asm/Kbuild                |    1=20
 arch/hexagon/include/asm/Kbuild            |    1=20
 arch/ia64/include/asm/Kbuild               |    1=20
 arch/m32r/include/asm/Kbuild               |    1=20
 arch/m68k/include/asm/Kbuild               |    1=20
 arch/metag/include/asm/Kbuild              |    1=20
 arch/microblaze/include/asm/Kbuild         |    1=20
 arch/mips/include/asm/Kbuild               |    1=20
 arch/mn10300/include/asm/Kbuild            |    1=20
 arch/openrisc/include/asm/Kbuild           |    1=20
 arch/parisc/include/asm/Kbuild             |    1=20
 arch/powerpc/include/asm/Kbuild            |    1=20
 arch/s390/include/asm/Kbuild               |    1=20
 arch/score/include/asm/Kbuild              |    1=20
 arch/sh/include/asm/Kbuild                 |    1=20
 arch/sparc/include/asm/Kbuild              |    1=20
 arch/tile/include/asm/Kbuild               |    1=20
 arch/um/include/asm/Kbuild                 |    1=20
 arch/unicore32/include/asm/Kbuild          |    1=20
 arch/x86/include/asm/irq_work.h            |   11 +++++++
 arch/x86/kernel/irq_work.c                 |    2 -
 arch/xtensa/include/asm/Kbuild             |    1=20
 drivers/ata/libata-core.c                  |    4 +-
 drivers/base/node.c                        |    1=20
 drivers/crypto/caam/caamhash.c             |    6 +--
 drivers/net/ethernet/3com/3c59x.c          |    2 -
 drivers/net/ethernet/broadcom/bcmsysport.c |   13 ++++----
 drivers/net/hyperv/netvsc.c                |   15 +++++----
 drivers/net/team/team.c                    |    4 +-
 drivers/pci/hotplug/pciehp_hpc.c           |    2 -
 drivers/tty/serial/8250/8250_pci.c         |   21 +++++++++++++
 drivers/usb/core/hub.c                     |    6 ++-
 drivers/usb/core/quirks.c                  |    4 ++
 drivers/usb/gadget/composite.c             |    1=20
 drivers/usb/gadget/function/f_fs.c         |    3 +
 drivers/usb/musb/musb_dsps.c               |    2 +
 drivers/usb/serial/cp210x.c                |    2 +
 drivers/usb/storage/uas.c                  |   17 ++++++++++
 drivers/usb/storage/unusual_uas.h          |   45 ++++++++++++++++++++++--=
-----
 drivers/usb/storage/usb.c                  |    9 +++++
 include/asm-generic/irq_work.h             |   10 ++++++
 include/linux/irq_work.h                   |    3 +
 include/linux/usb/quirks.h                 |    3 +
 include/linux/usb_usual.h                  |    4 ++
 include/net/sctp/command.h                 |    2 -
 kernel/irq_work.c                          |   15 ++++++++-
 kernel/time/timer.c                        |    2 -
 net/ipv6/ip6_gre.c                         |    4 +-
 net/sched/cls_api.c                        |    1=20
 net/sctp/sm_statefuns.c                    |   19 ++++++++++--
 64 files changed, 243 insertions(+), 52 deletions(-)

Andreas Bomholtz (1):
      USB: cp210x: add support for Seluxit USB dongle

Bryan O'Donoghue (1):
      serial: 8250: Add Quark X1000 to 8250_pci.c

Cristian Stoica (1):
      crypto: caam - fix addressing of struct member

Dan Carpenter (1):
      usb: gadget: f_fs: signedness bug in __ffs_func_bind_do_descs()

Felipe Balbi (2):
      Revert "usb: gadget: composite: dequeue cdev->req before free it in c=
omposite_dev_cleanup"
      usb: musb: dsps: kill OTG timer on suspend

Florian Fainelli (1):
      net: systemport: fix bcm_sysport_insert_tsb()

Frederic Weisbecker (4):
      irq_work: Force raised irq work to run on irq work interrupt
      x86: Tell irq work about self IPI support
      arm: Tell irq work about self IPI support
      arm64: Tell irq work about self IPI support

George Spelvin (1):
      libata: Un-break ATA blacklist

Greg Kroah-Hartman (1):
      Linux 3.17.1

Hans de Goede (4):
      uas: Add a quirk for rejecting ATA_12 and ATA_16 commands
      uas: Add no-report-opcodes quirk
      uas: Add US_FL_NO_ATA_1X quirk for Seagate (0bc2:ab20) drives
      uas: Add another ASM1051 usb-id to the uas blacklist

Joe Lawrence (1):
      team: avoid race condition in scheduling delayed work

Joe Savage (1):
      USB: serial: cp210x: added Ketra N1 wireless interface support

KY Srinivasan (1):
      hyperv: Fix a bug in netvsc_send()

Lu Baolu (1):
      USB: Add device quirk for ASUS T100 Base Station keyboard

Nicolas Dichtel (1):
      ip6_gre: fix flowi6_proto value in xmit path

Peter Zijlstra (1):
      irq_work: Introduce arch_irq_work_has_interrupt()

Sylvain \\\"ythier\\\" Hitier (1):
      3c59x: fix bad split of cpu_to_le32(pci_map_single())

Vlad Yasevich (1):
      sctp: handle association restarts when the socket is closed.

WANG Cong (1):
      net_sched: copy exts->type in tcf_exts_change()

Yasuaki Ishimatsu (1):
      driver/base/node: remove unnecessary kfree of node struct from unregi=
ster_one_node

Yinghai Lu (1):
      PCI: pciehp: Fix wait time in timeout message


--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUPk4zAAoJEDjbvchgkmk+fKUP/j8QwKmNaiRwXjoNpRRZWcze
vKuQ4uS0LQKEOgXEuhGYZPP2nhiLFXtCLfzdPBnilZFZJrEuJv8VSy3dO0gWpZ3G
+D806YDJOy8k8q69R5eQL3uWYTVZC5bSIUWHU/2uZyKiEIYcaiPOfi0ZRaGcApjy
7svIuk9dCW5OOisHApK7DPY5eIqBEP5Cr/juRyQpGJz2y1aVjx0e32UtDpgL8tGN
baf2Zbr8Tpc5ZhJFSOmqYQcdruU0+W6SCYiUigJ+GCqly8TzQtyPSsDZbQ76NPiL
eLy/LasFHfVP6z0S2Wm9UDRvWbVMQXw9svUCAY+CQtI2XejzFJJpn5qrJ3Mk7EVz
701qz72QGm1cH3YLeO/R2xH/DRddn3pEpOA4sLT5C3Im0AK4PNPqKKNvWaiyedLt
G1aCqEYOYopUycEkaXnzI8XzYMOhFrE/sTkcQz+qj1pudrgCqTm8pkX1MO7MfIF3
Q7iKWyBUtlphWkfUELE2JuecytAPqXgjrbGBr4C4Zn4IQKOivl0VQ2ZTP1APlFx3
x7hBArqXLa8EQVAH3Pz2LRpWAN2ak7Ju0im5JHDTOgvP3Mw0PqFTrnBAwerE1Bhc
vGroKW4FVcccMUdiS+vcPfedF7IYZ3hnA6+7pHf90qpE9JsUapQf0L2edR6/xbCs
XaR3NE88p72esqKWoxA2
=Z7jd
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
