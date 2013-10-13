Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3JMUMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 16:12:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46078 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755096Ab3JMUMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 16:12:39 -0400
Message-ID: <1381695143.1301.96.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [GIT PULL] firmware: wl1251 firmware binary
From: Ben Hutchings <ben@decadent.org.uk>
To: balbi@ti.com
Cc: dwmw2@infradead.org, Luca Coelho <luca@coelho.fi>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, Pavel Machek <pavel@denx.de>
Date: Sun, 13 Oct 2013 21:12:23 +0100
In-Reply-To: <20131002125535.GL1476@radagast>
References: <1380033894-5007-1-git-send-email-balbi@ti.com>
	 <1380107096.4503.8.camel@porter.coelho.fi>
	 <1380107278.4503.9.camel@porter.coelho.fi>
	 <20130925132359.GE10746@radagast>
	 <1380116535.4503.19.camel@porter.coelho.fi>
	 <20130925135943.GI10746@radagast> <20131002125535.GL1476@radagast>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DBu59udU/X2je7iwaB8D"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DBu59udU/X2je7iwaB8D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-10-02 at 07:55 -0500, Felipe Balbi wrote:
> Hi,
>=20
> here's a pull request for wl4 firmware. I'll send a patch for wl1251
> driver updating firmware load path.
>=20
> The following changes since commit b8ac7c7e27dcd13fa3c843aaf62457e9c57ea4=
db:
>=20
>   linux-firmware: Add Brocade FC/FCOE Adapter firmware files (2013-09-30 =
04:53:32 +0100)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/linux-firmware.git =
wilink4
>=20
> for you to fetch changes up to d726804dbc8dad88587b6be17716714cd91ed86c:
>=20
>   ti-connectivity: add wl1251 firmware and license (2013-10-02 06:55:39 -=
0500)
>=20
> ----------------------------------------------------------------
> Felipe Balbi (1):
>       ti-connectivity: add wl1251 firmware and license
>=20
>  LICENCE.wl1251                 |  59 +++++++++++++++++++++++++++++++++++=
++++++
>  WHENCE                         |  18 +++++++++++++
>  ti-connectivity/wl1251-fw.bin  | Bin 0 -> 194180 bytes
>  ti-connectivity/wl1251-nvs.bin | Bin 0 -> 752 bytes
>  4 files changed, 77 insertions(+)
>  create mode 100644 LICENCE.wl1251
>  create mode 100644 ti-connectivity/wl1251-fw.bin
>  create mode 100644 ti-connectivity/wl1251-nvs.bin

Pulled, thanks.

Ben.

--=20
Ben Hutchings
Beware of bugs in the above code;
I have only proved it correct, not tried it. - Donald Knuth

--=-DBu59udU/X2je7iwaB8D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUlr+p+e/yOyVhhEJAQp9zA/5ASDBSdmJ1UepzrtukikLusUFRMOTZ7Pd
V/tYpwhMCn7ODZd1VjP/Zeb7sZViOKMBdleiiI0zBRyLK4IX9Fpf0jIhSm+4TxEc
+Ls7pLid3BptfGi+m4Qbars/v4Fh3BVZ5OKAovQ4aZbYFDJevTLEMEUGHpEk+tkK
AJLV6C/dLYjVXklQGkNvfp9dBMhnXUbHZSt01XkHwJg8W8mdgb2KsczcVtYDKlpz
bJeRW49zOnkLW7LZVzE536f1EayQ0/a4ODUflxILkUdNHHsHoxE6gP1tLAPDZx3I
AjK2aFnbxnyqU4vqkBNbUKrNOVQjdXO4EsbqRYKShJNMywiA38Pmrj5cehy1AKlu
bqUWflabEDqOeNdv+VhPRBvds6mrHlDEY2uKRWmRUwIoFH7OZ0z8ZNe/gIQj253s
Y29LX2rqD/pVIzXkXhsj/RssksnPHdHLxRCu0+KrVclFRFRB0aU7desX9Md5AuOn
5uqPsc6n3l8cpOLXMbz9np2tn1QOa7zI0gZn8M3NrqnCLS3YvjpiGKjqn58Ioxq1
qkQbA/KuzSsg9hu00jNmsgbSVx+bLrPzMfkGfZIWoA6XR/VJ/z5E0UrbYetqQfL7
+zUcdXmkfcWHpDArwiMl052FGU8NrqSdB1B3a2rVSTehzQ8CqYevjQVPBdNO9wic
wQA2ekfAsnc=
=E/CI
-----END PGP SIGNATURE-----

--=-DBu59udU/X2je7iwaB8D--
