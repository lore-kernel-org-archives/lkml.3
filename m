Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaLPWNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:13:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaLPWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:13:05 -0500
Date: Tue, 16 Dec 2014 14:13:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.63
Message-ID: <20141216221303.GA5870@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.63 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                              |    2 -
 arch/arm/kernel/sched_clock.c                         |   13 +++------
 arch/powerpc/kernel/vdso32/getcpu.S                   |    4 +-
 arch/x86/include/uapi/asm/vmx.h                       |    1=20
 arch/x86/kvm/vmx.c                                    |    8 +++++
 drivers/ata/ahci.c                                    |    4 ++
 drivers/ata/sata_fsl.c                                |    2 -
 drivers/gpu/drm/i915/intel_lvds.c                     |   22 +++++++------=
--
 drivers/gpu/drm/radeon/radeon_kms.c                   |    2 +
 drivers/i2c/busses/i2c-davinci.c                      |    8 ++---
 drivers/i2c/busses/i2c-omap.c                         |   10 +++---
 drivers/media/i2c/smiapp/smiapp-core.c                |    2 -
 drivers/net/ethernet/broadcom/tg3.c                   |    3 +-
 drivers/net/ethernet/intel/igb/igb_main.c             |    2 +
 drivers/net/ethernet/marvell/mvneta.c                 |    2 -
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |    2 -
 drivers/net/xen-netfront.c                            |    5 ---
 fs/ext2/super.c                                       |    1=20
 mm/frontswap.c                                        |    4 ++
 mm/memory.c                                           |   26 +++++++++----=
-----
 net/core/rtnetlink.c                                  |    1=20
 net/ipv6/ip6_gre.c                                    |    4 +-
 net/sctp/output.c                                     |    4 +-
 sound/usb/midi.c                                      |    2 +
 24 files changed, 74 insertions(+), 60 deletions(-)

Alexander Kochetkov (2):
      i2c: omap: fix NACK and Arbitration Lost irq handling
      i2c: omap: fix i207 errata handling

Anton Blanchard (1):
      powerpc: 32 bit getcpu VDSO function uses 64 bit instructions

Daniel Borkmann (1):
      net: sctp: use MAX_HEADER for headroom reserve in output path

Daniel Vetter (1):
      drm/i915: Unlock panel even when LVDS is disabled

Devin Ryles (1):
      AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller

Dmitry Torokhov (1):
      sata_fsl: fix error handling of irq_of_parse_and_map

Greg Kroah-Hartman (1):
      Linux 3.10.63

Grygorii Strashko (1):
      i2c: davinci: generate STP always when NACK is received

Hugh Dickins (1):
      mm: fix swapoff hang after page migration and fork

Jack Morgenstein (1):
      net/mlx4_core: Limit count field to 24 bits in qp_alloc_res

Jan Kara (1):
      ext2: Fix oops in ext2_get_block() called from ext2_quota_write()

Nadav Har'El (1):
      nEPT: Nested INVEPT

Nicolas Dichtel (1):
      rtnetlink: release net refcnt on error in do_setlink()

Petr Mladek (1):
      drm/radeon: kernel panic in drm_calc_vbltimestamp_from_scanoutpos wit=
h 3.18.0-rc6

Sakari Ailus (1):
      media: smiapp: Only some selection targets are settable

Seth Forshee (1):
      xen-netfront: Remove BUGs on paged skb data which crosses a page boun=
dary

Stephen Boyd (1):
      ARM: sched_clock: Load cycle count after epoch stabilizes

Takashi Iwai (1):
      ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery

Tejun Heo (1):
      ahci: disable MSI on SAMSUNG 0xa800 SSD

Thadeu Lima de Souza Cascardo (1):
      tg3: fix ring init when there are more TX than RX channels

Todd Fujinaka (1):
      igb: bring link up when PHY is powered up

Weijie Yang (1):
      mm: frontswap: invalidate expired data on a dup-store failure

Yuri Chislov (1):
      ipv6: gre: fix wrong skb->protocol in WCCP

willy tarreau (1):
      net: mvneta: fix Tx interrupt delay


--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUkK5sAAoJEDjbvchgkmk+Rk8P/R85uRHlEbwOqNwju39JPhaV
3mBPISXvcwYbmDQnX0DpS/MahkHT8arKbB52EywvPGWsoV3pCn8V4QflE6fUiVBE
pKn1Le6dF956GNHkfrvIrmbep8mGNOKyB08W1o2wDqcC/CEiZzHCdvKk4czWQnTx
owRmCD51leXAQMDl13uu98btyLe8XsieLDYJXkz49/Im2y2gNZuR6qmv0onU7/w8
kYFdyhNgtN9xYvHVEbGbza/Wl5h+veyOw3M/hFVvkupVoGpmMlQYQXs7WS2Nn9/z
sSQ11SGasy8vSHo2AkrkT8KeUMFKKfIys562MkpYuXH1MnBYrEksLYdak3MEBP63
6nPMygygpd10WrCMzP2vFLKfcL5i5hcwdpjNq9WQaXxXqPqMaksoNGO+tLI9jLJs
FOHyyyFcOfZQTuS+Y04g6PBaACwmvmYdrge27wLMoDw9DOGZL3T9FDxqMYA7qmh2
ynCFPd2SabZbiAxKqZH4Hhl/6i3NagbXTuxJdm6oGAR993IoOPevCoiFJFiLOL7G
6DZurVX328PxfGIgub7UQPicX/8RH7V9jwsr54yNtHL7zsM4J/fflGQF2m+FN4hO
/2DaDMVbSOl9mtQtgv5oHgOsYTOj5DytBuvmooWBS4Dg6hUARMhyZdIcgiy66PwR
Ser6KqWM+gBEGjKOlKi9
=HWIn
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
