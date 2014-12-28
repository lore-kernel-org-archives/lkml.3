Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaL1Uax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 15:30:53 -0500
Received: from mail.ludd.ltu.se ([130.240.16.30]:46496 "EHLO mail.ludd.ltu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbaL1Uaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 15:30:52 -0500
Message-ID: <54A06874.7050006@gannon.se>
Date: Sun, 28 Dec 2014 21:30:44 +0100
From: Jonas Lundqvist <jonas@gannon.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Jeremiah Mahler <jmmahler@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: line6: remove spaces before commas.
References: <1419773206-18729-1-git-send-email-jonas@gannon.se> <20141228154442.GA24583@hudson.localdomain>
In-Reply-To: <20141228154442.GA24583@hudson.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="85QAh2DT8W5uqHgPRxT3NqnHJflKuh4M6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--85QAh2DT8W5uqHgPRxT3NqnHJflKuh4M6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Jeremiah,

On 12/28/2014 04:44 PM, Jeremiah Mahler wrote:
> Jonas,
>=20
> On Sun, Dec 28, 2014 at 02:26:46PM +0100, Jonas Lundqvist wrote:
>> Fixed three errors in pcm.h found by checkpatch.pl.
>=20
> What type of errors did you fix?

These errors:
drivers/staging/line6/pcm.h:148: ERROR: space prohibited before that ','
(ctx:WxE)
drivers/staging/line6/pcm.h:155: ERROR: space prohibited before that ','
(ctx:WxE)
drivers/staging/line6/pcm.h:162: ERROR: space prohibited before that ','
(ctx:WxE)


BR
Jonas


--85QAh2DT8W5uqHgPRxT3NqnHJflKuh4M6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUoGh7AAoJEBKd4UpXCeED7GEQAM7LWsihy830obDdHiLJj3Jz
P59xk1YDYMsfZhHPluqGWV93S/lvMFO4cHDZag4eudzrY3nYFs9nuvesri5sg5s/
TkavSigzDcVIV3u49Kylmz9cU6inMygeB0tnKB2wjZpf6nFp2RP8IjSmQplo6yNu
Oou6DPyytXqHqoDBFvfdg0vV/oEsdGgqLl8+OWoaIj4t5nhvWE/tAJIgtZPcqD7i
O5pzHIId6oj665HjkwfGcpq4HSBEXwVRX78sQKLD+3YZjQw187g+D+1NxNMG+M0W
frm7/ef7aRjrkEajzNawNAJg6Kxf7fR5cwrAuqTBAwQ77yEeXSgWKL2H6VvM7gnS
gEJC3+TsrWOl9mw7ux8tsODDzQgI4c8pCv51Qu2jfwWIB3MUESqKKmpvnkboZRtA
fDvxxIHzVUpeGdTw3D6xEIZk15OGIednULZhKRyZru8KJsDalWNZ6RREqCJ26zNm
aBaDRqABvf2ysujmoBq7dO01dhLq+c/R+ubQk6cbDRSK5KIHSRzrjfeIYZhO0R7Q
uEbZW1F0bdJ3YC2dyzPs1hZo0b8oAq0B/yQiMqFgoX4+La8THYXuAtxB6f322cDv
tnEiswBB1rl7k9dToR6h6Sf3u20uVoLt35NzfjovI9T1GM38CGIqnBPgGoue0VZT
gPctamEkyUFeLU75Ozmb
=95bY
-----END PGP SIGNATURE-----

--85QAh2DT8W5uqHgPRxT3NqnHJflKuh4M6--
