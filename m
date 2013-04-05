Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161315Ab3DELy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 07:54:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60989 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751Ab3DELy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:54:57 -0400
Message-ID: <515EBB8C.7090506@ti.com>
Date: Fri, 5 Apr 2013 14:54:52 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vgerk.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.9
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigF433C91C7698D054D07AF8CA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigF433C91C7698D054D07AF8CA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull two small fbdev fixes for 3.9.

 Tomi

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eef=
a9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git tags/fbdev-fixes-3.9-rc6

for you to fetch changes up to 090da752cdd6f0786eee68c8dea8db7c8abd3798:

  video:uvesafb: Fix dereference NULL pointer code path (2013-04-02 13:33=
:55 +0300)

----------------------------------------------------------------
Fix uvesafb crash bug and typoed flag name in fbmon's new videomode code

----------------------------------------------------------------
Jingoo Han (1):
      fbmon: use VESA_DMT_VSYNC_HIGH to fix typo

Wang YanQing (1):
      video:uvesafb: Fix dereference NULL pointer code path

 drivers/video/fbmon.c   |    2 +-
 drivers/video/uvesafb.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)


--------------enigF433C91C7698D054D07AF8CA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRXruMAAoJEPo9qoy8lh71FQ0QAJAk+uNwIfoY0U/g6TIebC97
GiU/TH4LBT1el6xmGdMTXxncgX5DWmUeXkbdhmhHBcOdvaZMlNuq2E3S8IvDklz0
/I7hU1hheAvUWPyk1BX5rE2advWJBumMEsk3OdvUVaWoIsnzSf/ZmrZTvweMBfKt
Vgg5RsngIuW2zUMfoUPHYvXF1bfilhgNUGdT1fm9XVYjvg4WwOjLDSgHdUJGJkIf
FH7u7YGrFQ+zSsB1CiRopgHdqij9Ah59ur4JP+OccluXEjQtIMHuomMk7QmMuOln
ayBEMIAxZt82XpdaEFwtd/ijSvoZH+U7ov0TlM6UNsqXbIRH/qkJ9Na59O1h1ops
Fh7dsjaUEetSNhKGSFxWz2lqK+EOnSh/9ARbYmA4a+0g909jhqESCDOOzBhSBBxN
RlksOaA8kdsyWVVpl3rdcxVv71GeeasvpB3rMSvVuw3wIr5EjWtIS3X22AnuAOs1
oirz04YbmKDEp7jWk9MUetiucsWwy3jpWrlv6pQzPwrbYc93yqWw6AIIKIG/QnOw
AvdPsVHYzul70fEZFd61Pyhqked3b32fi2OsBkEvN0KLfw3ugCp6cfXC487HoQBQ
VGeHxRCMLE/30xBFy2p4wgUgWm3sxg7DaXqVNdx06j/4MBE9AX0+VHQslRqAL8vf
+b2MemknPuzDwUt7pYD8
=5PT7
-----END PGP SIGNATURE-----

--------------enigF433C91C7698D054D07AF8CA--
