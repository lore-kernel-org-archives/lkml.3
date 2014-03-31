Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaCaSl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:41:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaCaSlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:41:24 -0400
Date: Mon, 31 Mar 2014 11:43:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.35
Message-ID: <20140331184343.GA3396@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.35 kernel.

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

 Makefile                             |    2 -
 arch/arm/include/asm/outercache.h    |    4 +-
 arch/arm/mach-highbank/highbank.c    |   13 +++----
 arch/x86/kvm/mmu.c                   |   12 +++++++
 arch/x86/kvm/paging_tmpl.h           |    8 ++++
 arch/x86/kvm/vmx.c                   |    2 -
 arch/x86/net/bpf_jit.S               |    2 -
 drivers/input/mouse/elantech.c       |   45 +++++++++++++++++++++++++--
 drivers/input/tablet/wacom_sys.c     |    7 +++-
 drivers/media/pci/cx18/cx18-driver.c |    5 ++-
 drivers/media/usb/dvb-usb/cxusb.c    |   21 +++++++++---
 drivers/media/usb/dvb-usb/dw2102.c   |   52 ++++++++++++++++++++++---------
 drivers/net/ethernet/intel/e100.c    |    2 -
 drivers/net/wireless/p54/txrx.c      |    2 -
 drivers/regulator/core.c             |   34 +++++++-------------
 drivers/usb/host/xhci-pci.c          |    5 +++
 include/linux/ceph/osd_client.h      |    1=20
 include/linux/ftrace_event.h         |    4 --
 include/trace/ftrace.h               |    7 +---
 kernel/sched/auto_group.c            |    3 -
 kernel/trace/trace_events.c          |    6 ---
 kernel/trace/trace_export.c          |    7 +---
 net/ceph/osd_client.c                |   57 ++++++++++++++++++++++++++++++=
-----
 scripts/package/builddeb             |    9 ++---
 sound/core/compress_offload.c        |    2 -
 sound/soc/codecs/max98090.c          |    1=20
 26 files changed, 215 insertions(+), 98 deletions(-)

Alexei Starovoitov (1):
      x86: bpf_jit: support negative offsets

Ben Hutchings (1):
      deb-pkg: Fix cross-building linux-headers package

Charles Keepax (1):
      ALSA: compress: Pass through return value of open ops callback

Dan Carpenter (4):
      media: cxusb: unlock on error in cxusb_i2c_xfer()
      media: dw2102: some missing unlocks on error
      media: cx18: check for allocation failure in cx18_read_eeprom()
      p54: clamp properly instead of just truncating

Gerald Schaefer (1):
      sched/autogroup: Fix race with task_groups list

Greg Kroah-Hartman (1):
      Linux 3.10.35

Hans de Goede (1):
      Input: elantech - improve clickpad detection

Josh Durgin (2):
      libceph: block I/O when PAUSE or FULL osd map flags are set
      libceph: resend all writes after the osdmap loses the full flag

Marcelo Tosatti (3):
      KVM: MMU: handle invalid root_hpa at __direct_map
      KVM: x86: handle invalid root_hpa everywhere
      KVM: VMX: fix use after free of vmx->loaded_vmcs

Markus Pargmann (1):
      regulator: core: Replace direct ops->disable usage

Michele Baldessari (1):
      e100: Fix "disabling already-disabled device" warning

Ping Cheng (1):
      Input: wacom - make sure touch_max is set for touch devices

Rob Herring (2):
      ARM: move outer_cache declaration out of ifdef
      ARM: highbank: avoid L2 cache smc calls when PL310 is not present

Sarah Sharp (1):
      xhci: Fix resume issues on Renesas chips in Samsung laptops

Stephen Warren (1):
      ASoC: max98090: make REVISION_ID readable

Vaibhav Nagarnaik (1):
      tracing: Fix array size mismatch in format string


--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTObdeAAoJEDjbvchgkmk+BjAP/iESK3u5h0DubltRWgNjHc7g
oOThnppVhgt/CICVxZSpplcPVkAH7qYq6goyZFz0us2Yuz4iCLe8JTh4dH8ItKRp
88jEo+rY5LQykOHxySIsF9mlsYSp2Fo08Af57JgS6Vwi7lLYMCuillpvjZ4k7/ki
jaPsDsyBY2N+2EH4WUV6smJjiMF0xU6GUXDKBgCRpLZ/JcZM7IwcrjZysU83gLnd
dWc1njdZbMF5+FOGGKRscVJ5WBgJUtU3oruQ/hzuQELDHeJSMYYxFLhWzz/29AWP
5AezNtpUCUuGC3h56kNxmmoh0YKz0lpD0gO6udHleIlk34MR3uqTuHRe0hHndbEY
wDh2WzQyKguAsSw9NaxcUX2FJ+fwi2REhTNzi5lX/mhyf9O1qJpKuKTpzy1fwNNs
Be//DRWBOH859u2IjM0Mbi7uet8YN/f4g8SUqx3ZP0tSVDnipqHFfJ3r9ShhhSyD
su8czFg0ftON7uHVdyGw9w1twZml/IC1ZSw1MkPuzppiCtE5tijPweR7VjblbMhg
3at2mpXmb2Wqs97vxv0dF34JaAg0EWu8xFw0kb2i78GhYNazounTODrzz99rkwnN
5LLbsXz30USsYU2WVClJ4LLBPa9O8uTXl7HarxGtLjDiRQO7Rdb6pF2+8hu28L5t
KxtBn5Akv0hbxiDBUOOy
=CBgW
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
