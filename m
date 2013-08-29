Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab3H2Rb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:31:59 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36042 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab3H2Rb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:31:57 -0400
Date: Thu, 29 Aug 2013 10:31:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.11-rc7
Message-ID: <20130829173153.GA1623@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Just a couple of new IDs in
Wacom and xpad drivers, i8042 is now disabled on ARC, and data checks
in Elantech driver that were overly relaxed by the previous patch are
now tightened.

Changelog:
---------

Mag (1):
      Input: xpad - add signature for Razer Onza Classic Edition

Matteo Delfino (1):
      Input: elantech - fix packet check for v3 and v4 hardware

Mischa Jonker (1):
      Input: i8042 - disable the driver on ARC platforms

Ping Cheng (1):
      Input: wacom - add support for 0x300 and 0x301


Diffstat:
--------

 drivers/input/joystick/xpad.c    |  1 +
 drivers/input/mouse/elantech.c   | 44 ++++++++++++++++++++++++++++++++++++=
----
 drivers/input/mouse/elantech.h   |  1 +
 drivers/input/serio/Kconfig      |  3 ++-
 drivers/input/tablet/wacom_wac.c | 10 ++++++++-
 5 files changed, 53 insertions(+), 6 deletions(-)

--=20
Dmitry


--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSH4WJAAoJEH70+W8r6ZYqPmMQAI6a3jlPtt5O42u/YR1hkIRo
vmRiLnvEFB8MvxWbgv5IwqdgMfKO/ccYeD8ALE6ygyR5AcqXmYD7fe1nmepgTexH
8a1nFtGuHoHtIA1Y9txRl84lwCuMNDA1zwpfPY/OvggWRtfA7FE1V0DRoQJmjOeT
oOXnXrE3novtbuL/cKuuMrHkhZu21Rb7aG15w73ee9LGDkHS7clKsfZZLzVjVehQ
NjZKIHXZDFAKw5lzh4PM4A9cBovOaspJSn9lIm58UIBpo6RmFLybywfIUfSwkJXt
a0RqlcnE97VEjNW0X7Dy0B9dkXe3Ioz11vUMp2cGPseFZ1ersZMJk2HUdDglNS+B
rMezOspYUFWnwWR/HcMBDzgXjibLiyLXo/0Lao6h0PgBAUuOIDgA4GY2BEoj6qn7
puooX2H25eTsXF4mp8ENljGWglbNufqXNxQnjpDs4pxnUAh7lh+t0lyq6mpfaziC
K3jgp7yTOlP2khaxpquw5V1ymMyOEsDz2Q5WfqitW0shyK2GpxiG95z/wKYjIPPV
/yaMzQyXzCveGTMlXDoaKXJDnENHxahvoa02UBddvdJ8Iqkp4Ls1XiH30yoOtMm2
zR7VSaddloKtJ7LfGvLb4mfcu+BG30jDgNOTW376fH75v9EGQIpekTPy8IYUyMMr
FaD8A0rcpFR2p6RqnIdD
=YS7B
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
