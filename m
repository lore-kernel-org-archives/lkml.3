Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaCaRwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:52:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbaCaRwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:52:01 -0400
Date: Mon, 31 Mar 2014 10:54:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.85
Message-ID: <20140331175420.GA1998@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.4.85 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 -
 arch/arm/include/asm/outercache.h                |    4 +-
 arch/x86/kvm/mmu.c                               |    3 +
 arch/x86/kvm/vmx.c                               |    2 -
 arch/x86/net/bpf_jit.S                           |    2 -
 drivers/edac/i7300_edac.c                        |   38 ++++++++++---------
 drivers/input/mouse/elantech.c                   |   45 +++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    7 ++-
 drivers/net/wireless/p54/txrx.c                  |    2 -
 drivers/usb/host/xhci-pci.c                      |    5 ++
 ipc/msg.c                                        |    2 +
 net/ceph/osd_client.c                            |   28 +++++++++++---
 scripts/package/builddeb                         |    9 ++--
 sound/core/compress_offload.c                    |    2 -
 14 files changed, 109 insertions(+), 42 deletions(-)

Alexei Starovoitov (1):
      x86: bpf_jit: support negative offsets

Ben Hutchings (2):
      iwlwifi: Complete backport of "iwlwifi: always copy first 16 bytes of commands"
      deb-pkg: Fix cross-building linux-headers package

Charles Keepax (1):
      ALSA: compress: Pass through return value of open ops callback

Dan Carpenter (1):
      p54: clamp properly instead of just truncating

Greg Kroah-Hartman (1):
      Linux 3.4.85

Hans de Goede (1):
      Input: elantech - improve clickpad detection

Jean Delvare (1):
      i7300_edac: Fix device reference count

Josh Durgin (1):
      libceph: resend all writes after the osdmap loses the full flag

Konstantin Khlebnikov (1):
      ipc/msg: fix race around refcount

Marcelo Tosatti (2):
      KVM: MMU: handle invalid root_hpa at __direct_map
      KVM: VMX: fix use after free of vmx->loaded_vmcs

Rob Herring (1):
      ARM: move outer_cache declaration out of ifdef

Sarah Sharp (1):
      xhci: Fix resume issues on Renesas chips in Samsung laptops


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOavMAAoJEDjbvchgkmk+c3IQALTi+dnb4nHdwfQbgHBtaRTD
2fjIKM/PZpEAPHf1psL+Yc8aVxQFzi0evaL7PM5dMTFjEfpP1R9NSiHb+wMw9R4A
DgX/bH0G53OX12wM1mHXxBTr7H9YIsV9bWkMyIhbPAg/6TeLVHNFaxEDk0JwrZvI
nwEz02poanogIC8LCp/TDXXYwTRI+0OFW+EPzvoTHWUtmI8YKewhO3wPN0C43oZa
kRZjtq/4Q027VooMxV/oP/vBa9Dk7lMdjznhAihdE4rh0uhyYDJAMI013x6Z6RW+
xhQBuydbK9y68v8wfuMMqfe0W64GmdY7LMEnS+uyNM2Yh4rt8pAf//DqqVSYdhOc
c39EO9V5xPU+mPhtCpweUW63IvG/mVeXbwYo++EHeQSj8W01q6b7D51kEqaUVvMo
5gehmxy1+GlEupRqE4UFAzt3mKIwb6HDHtrdhKB/ozzuOC2I7n62/n5igVrMkVMQ
pViLboK31Nah+uP4iQrc4fUGFaGuEUFhQFcknJLo8YSpcQi7LULI+MYVeVouX7dt
5CqSQl5kJ67ws0yzeMD/zdq3ahOlpk2TfyVTV5VpQnI+lFB9D8cexgIY1e/BAf1k
fxrCjrw2aVVdXFqHacBwdbHA9yS7X7DLE1EbVW9HNlx+5IneyNdgn/YlYxAUapPl
rGn5HQ6mGM8scJE8HQSX
=TtQm
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
