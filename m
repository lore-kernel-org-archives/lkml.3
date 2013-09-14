Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab3INOQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 10:16:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab3INOP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 10:15:58 -0400
Date: Sat, 14 Sep 2013 07:16:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.11.1
Message-ID: <20130914141615.GA12164@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.11.1 kernel.

All users of the 3.11 kernel series must upgrade.

The updated 3.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.11.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/hwmon/k10temp               |    1 +
 Makefile                                  |    2 +-
 arch/x86/include/asm/xor_avx.h            |    4 ++--
 drivers/acpi/ec.c                         |    4 ++++
 drivers/hv/channel_mgmt.c                 |   14 +++++++-------
 drivers/hwmon/Kconfig                     |    4 ++--
 drivers/hwmon/k10temp.c                   |    3 ++-
 drivers/misc/hpilo.c                      |    4 ++--
 drivers/misc/mei/hw-me.c                  |    9 +++------
 drivers/net/wireless/mwifiex/main.c       |   14 --------------
 drivers/rtc/rtc-max77686.c                |    4 ++--
 drivers/staging/imx-drm/imx-drm-core.c    |    1 +
 drivers/target/iscsi/iscsi_target.c       |   17 ++++++++++-------
 drivers/target/iscsi/iscsi_target_login.c |    9 ++++-----
 drivers/target/target_core_spc.c          |    9 ++++++---
 drivers/target/target_core_transport.c    |   11 +++++++++++
 drivers/usb/gadget/f_acm.c                |    1 +
 sound/soc/fsl/Kconfig                     |    4 ++--
 sound/soc/fsl/imx-pcm.h                   |    4 ++--
 19 files changed, 63 insertions(+), 56 deletions(-)

Bing Zhao (1):
      mwifiex: do not create AP and P2P interfaces upon driver loading

Fabio Estevam (2):
      ASoC: fsl: Fix module build
      imx-drm: imx-drm-core: Export imx_drm_encoder_get_mux_id

Graham Williams (1):
      usb: acm gadget: Null termintate strings table

Greg Kroah-Hartman (1):
      Linux 3.11.1

John Haxby (1):
      crypto: xor - Check for osxsave as well as avx in crypto/xor

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Fix a bug in the handling of channel offers

Lan Tianyu (1):
      ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

Mark Rusk (1):
      drivers/misc/hpilo: Correct panic when an AUX iLO is detected

Nicholas Bellinger (5):
      target: Fix trailing ASCII space usage in INQUIRY vendor+model
      iscsi-target: Fix ImmediateData=Yes failure regression in >= v3.10
      iscsi-target: Fix iscsit_transport reference leak during NP thread reset
      iscsi-target: Fix potential NULL pointer in solicited NOPOUT reject
      target: Fix se_cmd->state_list leak regression during WRITE failure

Sangjung Woo (1):
      drivers/rtc/rtc-max77686.c: Fix wrong register

Tomas Winkler (1):
      mei: me: fix hardware reset flow

Wei Hu (1):
      hwmon: (k10temp) Add support for Fam16h (Kabini)


--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNG+vAAoJEDjbvchgkmk+S4cQAL0I53s5dwHVTyhYIp+ka4vY
ZCyGsNcjQOHnmTFMVObddIYFjJ9z+tn54vT5Z82t/cYT6J71SpZvT2Il66c545YU
vNFDq/RFMk3qEReGOxGgXGh9asNaFG84eHUxwwaFMpwUMuvXmsgBxL9k3NjQ4p+s
Jl6CDEM3qDgcO2y9w/5P8ep4/JNCLQgq47PK8Gp1NqVUBTkjMtBlURbO25eleGQo
x/b/ULPe79bLmHfrtSC1Sdqk9L8G+Z5qfi1NAuqI4tChQJru1C0xNjZu35EKxUVG
e3Lc3zfiIzWU8aHP1Qbqwg0pgU84GPAmCAzpBt8fdjFw76piY7neS+YWBALSq2wH
hvzAozlxhNkL8ZbaDkwZ8wDtho2v0aTvCXJtG/KQCt71uaIW50GWYFpc6rdDqc5j
zGPiKUCH3rvLHhRGS8dAFVX3hx9QnAhvJXiedpbZfKCWwg5B/l/LNEZ3qo3Ibnpj
eRo6mO33BLkity+yf1hI1xHz/t4KgJEKNb0ZZgwEleeQlYOQ7BYspm7fdk3Z4q4p
QkjolX4a1zyHqD//ie1x3HxLSLkGIm9ySxPnthxqAUhnXPujyNrHxK+4rbSBQ/UI
x/Q8/fQP36ovhVROSQZvngKo/0RBo+6o+ViEKkT0AvstipTe5SoaWjAvqZbAoI1x
/em5hTzuL1W8dMxsLzLc
=Bwpg
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
