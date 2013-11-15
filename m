Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3KOPQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:16:09 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:60814 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3KOPQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:16:06 -0500
Date: Fri, 15 Nov 2013 13:15:54 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-11-11
Message-ID: <20131115151554.GB1627@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20131111182738.GB5648@joana>
 <20131111190548.GA8107@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20131111190548.GA8107@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

2013-11-11 John W. Linville <linville@tuxdriver.com>:

> On Mon, Nov 11, 2013 at 04:27:38PM -0200, Gustavo Padovan wrote:
> > Hi John,
> >=20
> > A few fixes for 3.13. There is 3 fixes to the RFCOMM protocol. One cras=
h fix to
> > L2CAP. A simple fix to a bad behaviour in the SMP protocol, and last, an
> > revert, that I sent in the last pull request but doesn't seem to be in =
your
> > tree.
>=20
> Are you looking in the wireless-next tree?  It seems to be there, no?

Yes, it is there. I'm resending this pull request without it:

Please pull or let me know of any problems! Thanks

	Gustavo

---

The following changes since commit 8ce9beac4661f576ea0d518b9f086bb52a171a37:

  drivers: net: wireless: b43: Fix possible NULL ptr dereference (2013-10-1=
8 13:41:11 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth for-ups=
tream

for you to fetch changes up to 86ca9eac31d0d8c4fe61b5726e6d63197bc435a6:

  Bluetooth: Fix rejecting SMP security request in slave role (2013-11-13 1=
1:36:54 -0200)

----------------------------------------------------------------
Johan Hedberg (1):
      Bluetooth: Fix rejecting SMP security request in slave role

Marcel Holtmann (1):
      Bluetooth: Fix issue with RFCOMM getsockopt operation

Seung-Woo Kim (3):
      Bluetooth: Fix RFCOMM bind fail for L2CAP sock
      Bluetooth: Fix to set proper bdaddr_type for RFCOMM connect
      Bluetooth: Fix crash in l2cap_chan_send after l2cap_chan_del

 net/bluetooth/l2cap_core.c  | 3 +++
 net/bluetooth/rfcomm/core.c | 3 +++
 net/bluetooth/rfcomm/sock.c | 6 +++++-
 net/bluetooth/smp.c         | 3 +++
 4 files changed, 14 insertions(+), 1 deletion(-)

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJShjqqAAoJEPs3PUX4s20oeWMP/RwYDHgjGIfe95axt3gMGz2M
TCWPaCeH64qpx+XljnvZOwg5hbos4Bq5oF9OZ2l7LA7PX8ROqfbFgnRBWEMXHz8j
1Zg54Y3DN0YoMaWkLjobE7TIVvyzikwAcL96gyfW/caYM88pCe7NWQvTs3FwEVET
jrLuOUAuMsXRNsZGwGqG0DMr8tVVam6el4hXLZ5Z58A9Ol3Kg7WbfijTsFH4PFjq
IriOKR5cEA7tSQPNMpKce+YBWgkPakEmAcYF9wAd7cQmbvl1AW0i5P6mlb8t9paI
2M/hD3mKncAD/8zh6E+hGRXIg+nEa81EryCIWYUNKV0C2sPCSI8ApX5P/H+fw/9p
HQ9YOktj6Oc5kEFO3bxDiEmQ4oem7U1ctNR4ULxzDUrI0oti9jxfma1XAFr/JncO
XfeXoLTD09vGbtjfAUk2+WlMXY9ltNx1lbNRmKPFtH0+Xxurtj9GScbdwKQ0gC4M
xe9Fq5uJgfg1wE6o+bHXFPAeT/WUMdq6EjtEut2KMffZGgASd6CSMKaeSTA3dXFH
ndPBrPSwOovm9kwzqO2UkrMoskmJc02QrB1yys2fn3scgMzTMyWWHMWq4kRRle5q
TeNKFW4A+XnFa8w0B+upTt98Dm1A8VN1ztl4s8mQ5sP7E0yYwvJ9aDfD3VSHhJXt
p9IMJxdPvOzF8PFYxPP2
=rg0f
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
