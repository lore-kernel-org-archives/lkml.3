Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbaE0TxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:53:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44722 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaE0TxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:53:12 -0400
Date: Tue, 27 May 2014 20:52:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, arnd@arndb.de, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140527195258.GF12304@sirena.org.uk>
References: <1401208054-16955-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRByYCmEBrlccKn0"
Content-Disposition: inline
In-Reply-To: <1401208054-16955-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND v2] regulator: arizona-ldo1: add missing #include
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRByYCmEBrlccKn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 05:27:34PM +0100, Charles Keepax wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> commit 2cce4be9e6b8 "regulator: arizona-ldo1: Add processing of init_data
> from device tree" added a call to of_get_child_by_name() but
> did not add an #include to the header file declaring that function.

Applied, thanks.

--TRByYCmEBrlccKn0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThO0WAAoJELSic+t+oim9r1QP/0hnF2loUtbdYgV1ZbkiGR3R
VaGXkZnhsIhym6fR7YAhZDy6ZJzxuhI64IBjwCNuZzirdasa3a+k09LNf1fROL5V
byhrNcoqrrMgiH0FA8UAE8untnUGKEc3Qx2iQoSXkRlHqc7JaF4pJ1TgciVSSQNG
VjKomT/UBf/1KR2kA3sZgqWUBuhCAmb93wva9Y1LI6vkIkUTY6TkFxxvqrhawY/O
QRsch+CDGWYDiEYPybbijqyTJFEt1LlPMWI/hTdZxZDObGJn4QvS+i7GOIt7UFbh
avOy9kuCk48Q/TeZnKt7XqMbsAbMYoTNXMEMn0nHVkTHf6gmqk5kezoke11OfC+O
aT955hUsveQ1JbY3ec5sj3vaLPwYa4eL0uhbhGn8ld1nD/YhSBP6E8AkoiAlI/j1
ijoH+Fjrrs1N7qiRTN0Xw75T9JOCz8aLcV7oVWpPVFvqrIJzflP2OgVdA21XGF29
6tfvUd5uQ/OQIXwsRfhTLehe2QRTE9tANodSsq7I5uOpmh2BSkINFtU32AOmWbB+
mJc6E9cxcaEmUTFvLrt0a8AG5YwejJpGbpGQdR6uGmjtBZK9zf4Zj5nedNRp8mvP
Rxyl5sr1ASkNF7uTM1Rz4d/6i6BONcit7E73eVosQdnBIIie8dl0Nx7UUaEd/pqR
ZAkndaqrp5769+zjGN+8
=ZK/i
-----END PGP SIGNATURE-----

--TRByYCmEBrlccKn0--
