Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab3ENX4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 19:56:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35571 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538Ab3ENX4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 19:56:09 -0400
Date: Wed, 15 May 2013 09:55:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@risingtidesystems.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: linux-next: Tree for May 14 (vhost_scsi)
Message-Id: <20130515095558.918f2b29ba318a477eb5dde2@canb.auug.org.au>
In-Reply-To: <51928D84.2040305@infradead.org>
References: <20130514141739.46eb9b42c95cb02947610379@canb.auug.org.au>
	<51928D84.2040305@infradead.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_May_2013_09_55_58_+1000_ylBDgaB6c8OvGGEA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_May_2013_09_55_58_+1000_ylBDgaB6c8OvGGEA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Adding Michael to cc]

On Tue, 14 May 2013 12:16:20 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> on x86_64:
>=20
> ERROR: "memcpy_fromiovec" [drivers/vhost/vhost_scsi.ko] undefined!
>=20
>=20
> It needs to depend on NET since net/core/ provides that function.
>=20
> --=20
> ~Randy

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__15_May_2013_09_55_58_+1000_ylBDgaB6c8OvGGEA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRks8OAAoJEECxmPOUX5FEmZYQAI8MJATooxMhrJVWJ8Qnzn0V
TjJ9LftxyAXDCa1lfGZzI29I6y8fPNIt5YnwbBIWxfIqGKVzoCS7i83wdKjKm3/q
8CXkMAuErner+EsisdzZ+0HcRVnkRi6cy0nIw5Sa6D1c+wnB6R4b0SBPe7YzA5pL
qJdJtmJpa47fDEHdPmMTV+TddZdWz3W/AryxZlm8JwQJKiCYs2xB3Z2+goNJudgJ
MbUOyiKO6s71Dk5VIEfOzPdHSolybHPerhK+l4uo4Rnua85tsgLp8BqGtzn5to8H
QTsJ+ImVpRVOwxyRxhkP6OJiOZi7rDxRX9m5GT9x+TKITGO/D3wfDwBQ/0+EMjve
f0BUZdsTio/XV9IM+/UlfP1GHVZKMnJ12pwZqj6fVAqVLNQrZgk0PsYeYUeYpXvW
B9IBgbfNqzB2o93IpRRYTbY1z8tZDiJs05VfEzkZcf2UQ+m6njVSPGvxwIKgmy5F
EIVGOBDhBXHIJe5fNinUekBcqhpwAhy2FUmTJ7DrU3pjwZ8bRTG9siN7nieMMWe1
0rS11B6+5Ykvbag/WOVFrSUaiVE0LjL+tPZgskXfNH593xfp0XzVBzTjHsZXBFFb
Qkg69o4tIfaMgY5G2e39O63MipbTyO89MYDP+MG+cr/Cdwf4nhlEd5Yi71KXXyoK
96nhx+Fp87kXHI18F64R
=qIRq
-----END PGP SIGNATURE-----

--Signature=_Wed__15_May_2013_09_55_58_+1000_ylBDgaB6c8OvGGEA--
