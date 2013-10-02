Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3JBM4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:56:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48092 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3JBM4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:56:20 -0400
Date: Wed, 2 Oct 2013 07:55:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>, <dwmw2@infradead.org>, <ben@decadent.org.uk>
CC: Luca Coelho <luca@coelho.fi>, <ben@decadent.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, Pavel Machek <pavel@denx.de>
Subject: [GIT PULL] firmware: wl1251 firmware binary
Message-ID: <20131002125535.GL1476@radagast>
Reply-To: <balbi@ti.com>
References: <1380033894-5007-1-git-send-email-balbi@ti.com>
 <1380107096.4503.8.camel@porter.coelho.fi>
 <1380107278.4503.9.camel@porter.coelho.fi>
 <20130925132359.GE10746@radagast>
 <1380116535.4503.19.camel@porter.coelho.fi>
 <20130925135943.GI10746@radagast>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pdSIrcRjgC24tZqG"
Content-Disposition: inline
In-Reply-To: <20130925135943.GI10746@radagast>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pdSIrcRjgC24tZqG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

here's a pull request for wl4 firmware. I'll send a patch for wl1251
driver updating firmware load path.

The following changes since commit b8ac7c7e27dcd13fa3c843aaf62457e9c57ea4db:

  linux-firmware: Add Brocade FC/FCOE Adapter firmware files (2013-09-30 04=
:53:32 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/linux-firmware.git wi=
link4

for you to fetch changes up to d726804dbc8dad88587b6be17716714cd91ed86c:

  ti-connectivity: add wl1251 firmware and license (2013-10-02 06:55:39 -05=
00)

----------------------------------------------------------------
Felipe Balbi (1):
      ti-connectivity: add wl1251 firmware and license

 LICENCE.wl1251                 |  59 +++++++++++++++++++++++++++++++++++++=
++++
 WHENCE                         |  18 +++++++++++++
 ti-connectivity/wl1251-fw.bin  | Bin 0 -> 194180 bytes
 ti-connectivity/wl1251-nvs.bin | Bin 0 -> 752 bytes
 4 files changed, 77 insertions(+)
 create mode 100644 LICENCE.wl1251
 create mode 100644 ti-connectivity/wl1251-fw.bin
 create mode 100644 ti-connectivity/wl1251-nvs.bin

--=20
balbi

--pdSIrcRjgC24tZqG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSTBfGAAoJEIaOsuA1yqREaF8P/AjKcMlM+XhdjWGRzwSLSy6/
c7yfYCnENqTWvicheSNl0kanY3oMK2WigFU/0pXcLGl25NwqA9GobIk9EksUo4Ya
i40r4TFskL5Wfikqohl2DEhpzbpgyPQTqTxanceDYFTB4RCC+VgciHpBTso3oD83
+y9Q4QAHTkTO9DS8IPoQKqYy54+PNgk4iYNndnl6W/kWm6N7H5HTNcQ+Judf0SuL
0NYAh+Wfvw+0Uc3q7hlICQLuz1I4RRnw8dNVdd8D3ybsjlR15WpRmPPuP6EoXCRl
MXR1+YHmXHjkRG1rgYTolOtlfT66czSxGP4GQv6QNvPcojH/+UotjG7fZ6U61Ia7
JJEp4TCLVUwXJ/cYvbcnO7e013K8IVAXcmhgsJNEyRxJ4JtmN5r+38JWhKeogVuf
lsAUw3yMkf/hIY/8cIFwy7HQ5dDP6aQ4/hYQ11dC53h+zjOUG2mLAWGU7cGGeZ28
lQveHnQ1bme6NXzwEJ75u+4+6eqxoUAtIbmjSfRtSMp0CJjhUk35HvXEPnnRJJhe
FdqfpLcHrtloeC5IcwVelTRJI82EDQrIBVIrtLWue2ZW0IoAgMcw2EhBwca2uCpM
B8D/zko79h4/ikxw8rrJzHQmu2kAhU5KOgz24j1J9xpNaoULvy3VRp9GRTi/GRXC
lYPB3UHoN+2XuXVZTasS
=OEhv
-----END PGP SIGNATURE-----

--pdSIrcRjgC24tZqG--
