Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaKRUjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:39:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47436 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbaKRUjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:39:05 -0500
Message-ID: <546BAE64.7030406@pengutronix.de>
Date: Tue, 18 Nov 2014 21:39:00 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: can: remove unused variable
References: <1416318427-28676-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1416318427-28676-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2SIFd2A4enKJhnqeVUJotQIuriOILaqj9"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2SIFd2A4enKJhnqeVUJotQIuriOILaqj9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/18/2014 02:47 PM, Sudip Mukherjee wrote:
> these variable were only assigned some values, but then never
> reused again.
> so they are safe to be removed.

Thanks, I've applied both patches.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--2SIFd2A4enKJhnqeVUJotQIuriOILaqj9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa65kAAoJECte4hHFiupU4k0P/iJTMIH/d2Shj0PibwHfTbz/
oz5DalefJNoxkaMcmbpOMHRn27KwJijCbn+G5Dgy5HA7kKp1Y2fkITqjlqlwS5AE
z5jH4zXDW4IzzsloZhy1XSLzVW56UIh1H8lcd2fyLNn8Qa+QQ25/QxRTLtokKXXx
TBwrK03yjt3R9Mj1pvaoc7yUSYxLChjvoYl9i9bVh9xEeQLj3wBP0KdJmjxWnd1Z
Sq6AmuZXrIi2crNeBoQCCJZwYEPr60UCDKFpltjHjcWk3eZKHNE4kkEj2jef39dn
jBmclYsPh5UINByZK4Xu+nDo0cFioMXyd7CcjghRfqYOfrueWOsnDT99UrWpd5XR
2TDHSOF0qFxN09+RdPBHe70e0ONfiTJHIQvBNEG3AVyFJxrkFqAfDZYzTVmB4re4
xe8L4S0U+yyuOmwadrHHnPpJXHazABBmv9Va2uFOU2bigSnWWLU82rlHFLgyqlse
qxhve57jq/t2VR01q/5HjbUQvuJ9VL1FJPo5lt9r9aA4GufZ1ZLRnKnFYe0G4LJ1
xpo43iWuuxt6xOYl8WXCmQOc7mvmuFsKAPOkw+ojO8uOq5WewuTgEbNpJjbDE9Pw
Eq6xYsCs9Dc643wlSxS7JAY0/VvItDeXwAWWCSaL58zIQOIUFleOxodFrTsKv4Cx
Xb8jeYEoQiPVB4snH/2t
=NaXV
-----END PGP SIGNATURE-----

--2SIFd2A4enKJhnqeVUJotQIuriOILaqj9--
