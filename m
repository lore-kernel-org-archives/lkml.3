Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3FWCN7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 22:13:59 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41157 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3FWCN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 22:13:56 -0400
Date: Sun, 23 Jun 2013 03:13:51 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-06-23
Message-ID: <20130623021351.GA2327@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

A important fix to 3.10, this patch fixes an issues that was preventing the=
=20
l2cap info response command to be handled properly. Please pull. Thanks!

        Gustavo
       =20
---
The following changes since commit fcb3701849957917a234a61b58ad70ed35c83eda:

  brcmfmac: free primary net_device when brcmf_bus_start() fails (2013-06-1=
3 13:24:12 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to 3f6fa3d489e127ca5a5b298eabac3ff5dbe0e112:

  Bluetooth: Fix invalid length check in l2cap_information_rsp() (2013-06-2=
3 00:24:58 +0100)

----------------------------------------------------------------
Jaganath Kanakkassery (1):
      Bluetooth: Fix invalid length check in l2cap_information_rsp()

 net/bluetooth/l2cap_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRxlnfAAoJEPs3PUX4s20oCq8P/j8Yag3fDWz8CjlJbYVqMsMw
wyEU825uw6WYYfGksV6lGGWWFlqPDuKcsQ/NosGB/I7Hn1m9CuIESeuowiu/aw+V
ZfHLVMe3x5NH/7lwPELHemBwKTGRVahaC7itP8sqOah0x8XG6WrIN6L75l+RR+3y
EV0y3lcDmRiNA/BP0EVuuhjORUpfKuoQrJSea+Q7vtk16aLutlohHo4gFlij4E54
lOht8Rc+FVDhL86rqg0ZrtkWc1aSmjjMLFpWV0hEzk+TaU4P1I6AMT1kPEVjK+5D
39R4Eskw29PqsQq5Iz9MdTlODol0RQ2AVnMjd26ICjZM3PjujG8AgHF0RNKwlZO2
Mgh5Iredhm7yGHMqiZ05jaOB3UIakKufx3wjaRViXUIGAYHrxe1kZ3FMHYSOAr38
TxPnj7s3p8OG/Qf3wyUp4Lwz2KK0uZSgluNfZV6Uj2fjWvDgDupNXrXF0uz+PaUW
zhi6OH5ui3I+Gf9HXeolRs5A7xx4fB+h16yHhFkhqip3ZolRB8NL5wNYBnhT1cz3
EWmoZsnfFrpX+oic96rL8+8jQSIv3wBth3wM4HE9lRKlP3F+rsUhRcw92VX33hgn
rwxCtObpaMbvs/6pKgTEKwUGsUK3Vs1psMxZrBBvW7LA775/BSoBdDBTbxUnclU3
yLJ4+4SiQ5ENLoVF4ogO
=hO+l
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
