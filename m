Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157Ab3EGANB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:13:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35213 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab3EGAM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:12:59 -0400
Date: Tue, 7 May 2013 10:12:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: unable to fetch the watchdog tree
Message-Id: <20130507101246.1337bb2362b2f9fc202923fc@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_May_2013_10_12_46_+1000_a1N/+xvawgSrZyMi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_May_2013_10_12_46_+1000_a1N/+xvawgSrZyMi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Trying to fetch the watchdog tree
(git://www.linux-watchdog.org/linux-watchdog-next.git#master)
pauses for a long time, and then produces this error:

fatal: read error: Connection reset by peer

I will continue to use what I previously fetched.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__7_May_2013_10_12_46_+1000_a1N/+xvawgSrZyMi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRiEb+AAoJEECxmPOUX5FE+YUP+gMwz/hos811YhAuuN2MxrJH
hb0QYiM9mu0OjQisofAZZkaUakGxCV2yiNtUqobjLff5WS5zyctRKqB9A6o4v8t+
0XROmfyuMIMrhwWGB81CNjulaUix9hYtsUweYZ9F7J4UkYZrI/adZqa+WAfCj0GM
DWsn/Fg9+Db7Ka1/7wT+EKeHqTBjFiBp+cV2mrp3qUIitj2FPMW4l859+p0Dfe82
LWbCDTxIpQheIKoSneIoTyZcbTNxftFqOFQ/gf1+gk71+vEHACIBPgGPQcc9aeew
uTiBEMhP4wqVUyMSinCOsetyjN3PDNClI5DH+3mufCKblGu+gTQeYN9CRWEHk0Y5
vUly3LwBYZw8ioK7DTROHcmBbDE5pEbzuVph4lQi7eTnzMDJTexfBkte+jMipS9L
h6FLEfe/VVmeZ0m6SPpsmOrz7V1INlw4GlmSIEr+Xo1h88i0SN2/oI1k7TVtrO2a
ePuRRpkE8kDqUNZlPuRaRbq3nlLWbbViC3eE0pYIJFaGjtRDDL9eH7cJonReCMdX
6G8V6zbXs/i5/I2kma3E7r8kke1CWx59bkuVDi/wsVQqRzJvp/GtX3RCOmfwzAW/
cCJSudWxSrj75e+l1/syFpAXOpiG1r/tFJ+qfIkMtuU2uY0JlqTArlEVELDOD4l4
L9sUKe0CLEqrvcBPS00P
=ULzQ
-----END PGP SIGNATURE-----

--Signature=_Tue__7_May_2013_10_12_46_+1000_a1N/+xvawgSrZyMi--
