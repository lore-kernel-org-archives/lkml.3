Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3G0Pjt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 11:39:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59688 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261Ab3G0Pjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 11:39:42 -0400
Message-ID: <1374939571.13555.26.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 02/79] sparc32: vm_area_struct access for old Sun SPARCs.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Olivier DANET <odanet@caramail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sat, 27 Jul 2013 16:39:31 +0100
In-Reply-To: <20130726204722.156069119@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
	 <20130726204722.156069119@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ifjiR4gn8qxjR+pKabm0"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ifjiR4gn8qxjR+pKabm0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-07-26 at 13:46 -0700, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Olivier DANET <odanet@caramail.com>
[...]

This is missing the upstream reference.  It was commit
961246b4ed8da3bcf4ee1eb9147f341013553e3c.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-ifjiR4gn8qxjR+pKabm0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfPps+e/yOyVhhEJAQrHJw//UbUt2rxK+T6jKInmLQOhKdMen07ojrkB
xJ/SfbqlZeh+UawQe95+DImvGDjsQLaY/DxdZ59PRNDv19ep2sYHsWsJg9WBTiTw
J+w37Rfa3gMFvZ+Y2F+KUtPB7dQDTug9febJXbDakLonloM65deKNvb2WBuEsWpI
90uyMbjmMnx+UuufRrPTaG1WTnrWZzAYleOfx6CE2LiQdoUmaQ6UQ0ojaHAYMPd8
h6k2JJ4Befxq9lNl3IZ+XpfIf/P+BdDhBCWMAawcO2AYSo+ZVDw1S4Jqe/KU5uuQ
oHR3N7clGEbfZ/aTAhIwEmtR24OI+TTpPIquuxDzOrqheqCmoRQJlIP3iuQUnxc/
87Cp/Lv9jCgSxnF80/G7NmADSQ5c7H/x1xrSBr/UEnBCmPwdcQW8ifvRLDdz9fKt
i815NsZcpHBlGwPe2joxDRFlBvccFYPOpkgATWs9dPS7NJ//cxOj1UgvvG2W5qpx
jF1xERKFw5FqTF93lN9+sPgY9eGWpj8/0qGO9pIh6FJ1A62tyvdkzZ88PjZlrhWJ
CJkQIWOxovZQh1nqtKrh/NPdUzekXmdUIoqUHBnPgzkLCmEskdbKCmWj3L4FVTl1
F7jUDVtodCoTGrFct8++jNJlyKBsBELziyKl3DIs2tWMszVAkJkUXCVYI55EkeSp
9/L4rPKt2oI=
=MrQN
-----END PGP SIGNATURE-----

--=-ifjiR4gn8qxjR+pKabm0--
