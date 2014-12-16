Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaLPWNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:13:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaLPWNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:13:32 -0500
Date: Tue, 16 Dec 2014 14:13:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.27
Message-ID: <20141216221331.GA5952@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.27 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                              |    2=20
 arch/powerpc/kernel/vdso32/getcpu.S                   |    4 -
 arch/x86/boot/compressed/Makefile                     |    2=20
 arch/x86/kernel/cpu/perf_event.c                      |    3=20
 arch/x86/kernel/cpu/perf_event.h                      |   12 +--
 arch/x86/kernel/cpu/perf_event_intel.c                |   66 +++++++++++++=
++++-
 drivers/ata/ahci.c                                    |    4 +
 drivers/ata/sata_fsl.c                                |    2=20
 drivers/gpu/drm/i915/intel_display.c                  |    2=20
 drivers/gpu/drm/i915/intel_lvds.c                     |   22 +++---
 drivers/gpu/drm/radeon/radeon_kms.c                   |    2=20
 drivers/i2c/busses/i2c-davinci.c                      |    8 --
 drivers/i2c/busses/i2c-omap.c                         |   10 +-
 drivers/media/i2c/smiapp/smiapp-core.c                |    2=20
 drivers/net/ethernet/broadcom/tg3.c                   |    3=20
 drivers/net/ethernet/intel/igb/igb_main.c             |    2=20
 drivers/net/ethernet/marvell/mvneta.c                 |    5 -
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |    2=20
 drivers/net/vxlan.c                                   |   10 --
 drivers/net/xen-netfront.c                            |    5 -
 drivers/usb/host/xhci-ring.c                          |   40 ++--------
 drivers/usb/host/xhci.c                               |   60 ++++---------=
---
 mm/frontswap.c                                        |    4 -
 mm/memory.c                                           |   26 +++----
 mm/mmap.c                                             |   10 +-
 mm/rmap.c                                             |    6 +
 mm/vmpressure.c                                       |    8 +-
 net/core/rtnetlink.c                                  |    1=20
 net/ipv4/gre_offload.c                                |    3=20
 net/ipv4/ip_vti.c                                     |    1=20
 net/ipv6/ip6_gre.c                                    |    4 -
 net/ipv6/ip6_vti.c                                    |   11 +++
 net/mac80211/aes_ccm.c                                |    3=20
 net/sctp/output.c                                     |    4 -
 sound/pci/hda/patch_analog.c                          |    1=20
 sound/pci/hda/patch_realtek.c                         |    1=20
 sound/usb/midi.c                                      |    2=20
 37 files changed, 201 insertions(+), 152 deletions(-)

Alexander Kochetkov (2):
      i2c: omap: fix NACK and Arbitration Lost irq handling
      i2c: omap: fix i207 errata handling

Andrew Morton (1):
      mm/vmpressure.c: fix race in vmpressure_work_fn()

Anton Blanchard (1):
      powerpc: 32 bit getcpu VDSO function uses 64 bit instructions

Chris Clayton (1):
      x86: Use $(OBJDUMP) instead of plain objdump

Daniel Borkmann (1):
      net: sctp: use MAX_HEADER for headroom reserve in output path

Daniel Forrest (1):
      mm: fix anon_vma_clone() error treatment

Daniel Vetter (2):
      drm/i915: More cautious with pch fifo underruns
      drm/i915: Unlock panel even when LVDS is disabled

Devin Ryles (1):
      AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller

Dmitry Torokhov (1):
      sata_fsl: fix error handling of irq_of_parse_and_map

Eric Dumazet (1):
      net: mvneta: fix race condition in mvneta_tx()

Greg Kroah-Hartman (1):
      Linux 3.14.27

Grygorii Strashko (1):
      i2c: davinci: generate STP always when NACK is received

Hugh Dickins (1):
      mm: fix swapoff hang after page migration and fork

Jack Morgenstein (1):
      net/mlx4_core: Limit count field to 24 bits in qp_alloc_res

Kan Liang (1):
      perf/x86/intel: Protect LBR and extra_regs against KVM lying

Marcelo Leitner (1):
      Fix race condition between vxlan_sock_add and vxlan_sock_release

Mathias Nyman (1):
      USB: xhci: Reset a halted endpoint immediately when we encounter a st=
all.

Nicolas Dichtel (1):
      rtnetlink: release net refcnt on error in do_setlink()

Petr Mladek (1):
      drm/radeon: kernel panic in drm_calc_vbltimestamp_from_scanoutpos wit=
h 3.18.0-rc6

Ronald Wahl (1):
      mac80211: Fix regression that triggers a kernel BUG with CCMP

Sakari Ailus (1):
      media: smiapp: Only some selection targets are settable

Seth Forshee (1):
      xen-netfront: Remove BUGs on paged skb data which crosses a page boun=
dary

Takashi Iwai (3):
      ALSA: hda - Add EAPD fixup for ASUS Z99He laptop
      ALSA: hda - Fix built-in mic at resume on Lenovo Ideapad S210
      ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery

Tejun Heo (1):
      ahci: disable MSI on SAMSUNG 0xa800 SSD

Thadeu Lima de Souza Cascardo (1):
      tg3: fix ring init when there are more TX than RX channels

Todd Fujinaka (1):
      igb: bring link up when PHY is powered up

Tom Herbert (1):
      gre: Set inner mac header in gro complete

Weijie Yang (1):
      mm: frontswap: invalidate expired data on a dup-store failure

Yuri Chislov (1):
      ipv6: gre: fix wrong skb->protocol in WCCP

lucien (1):
      ip_tunnel: the lack of vti_link_ops' dellink() cause kernel panic

willy tarreau (1):
      net: mvneta: fix Tx interrupt delay


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUkK6LAAoJEDjbvchgkmk+7lsQAITzeiKOlX7SA4uvIphbKCfa
QT6dD13ylt3Th4q0XannyFJsUT0B7egPmbT7io/LFtBCHDycq/1veQwb2+Lq0kDa
rGTEiWc8P0Irlb+bWJCc+S3McUp163RZJDNztfgmph+ESueRbN6ppVEempcX9Ars
jBepN+v7gmDPEFI8nDLdgYoVduHt3T5eqgKSc0GwL9E7DFtHfhHxoiAwXqcGkzKe
bqOIgf3RVEUXEcr2JZk6fUDE9EJ+BDqAo+u1Wa/eG/wS/qESt3EzKfbhM0vgMP1H
aXDOUKMQuzAxdUCmphm52gq3G66F5rR55MSwshq0c5cmOnThMLrGfPb+ysgiRY9A
u+wJG/aZle2v8WCtgfCGz7PTpxtQgRjx00tCK9YMBJiaIOGekApIzdwCH3PeiGwV
AO7w+//8XI6p7lQTuY+mi7cVt8RQOCLsOmjzC5XSEKs5D25f8rZiWNSkmjBnX4Eo
4OcYvX9xVnhYKXuzD28Dh7p4Na8W/D3T4Anbj/XufcDlnTqF9lP3tUafkj11vgU5
XssYgit84ofd9Xu2V+F8V4Dzo6j0NDmcLY3UKFZ/qyeY+mOiXirC9pBCKW4Llw8d
plQrgfuMGN+1LfqbYyTHJi68N8VxqH8ZxmwtiXMzZ9gbKDlMpuhJ/8Nwq/vNklMC
OU6a8LQBnZyasfs0IT6T
=xktm
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
