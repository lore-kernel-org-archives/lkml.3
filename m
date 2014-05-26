Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaEZPiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:38:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43354 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaEZPiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:38:17 -0400
Date: Mon, 26 May 2014 16:37:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20140526153716.GX22111@sirena.org.uk>
References: <1400483625-29312-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ben6AifVmj+t9BPa"
Content-Disposition: inline
In-Reply-To: <1400483625-29312-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: irq: Fix possible ZERO_SIZE_PTR pointer
 dereferencing error.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ben6AifVmj+t9BPa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 19, 2014 at 03:13:45PM +0800, Xiubo Li wrote:
> Since we cannot make sure the 'chip->num_regs' will always be none zero
> from the users, and then if 'chip->num_regs' equals to zero by mistake
> or other reasons, the kzalloc() will return ZERO_SIZE_PTR, which equals
> to ((void *)16).

Applied, thanks.

--ben6AifVmj+t9BPa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg1+pAAoJELSic+t+oim9ai8P/3ev7Zh2QgTaFYKfA3q/l/1s
zyLrfXPyNdBXxK/i947NUy0K2Kx+chieAXMhz4Cf0CN1p4qAVUT0bH8Q7otztWn0
qHYTJvDe1hfHstNXK/tQG7Z+ihjf+qIIq0Q2pLDw7DsreOFXg0ZkTFwMzmKQeGiW
IxWdn7XisOUsPSyhbZhEovhyKO5qyIRiq8vJ0wWYWtOkNIvF7fOOsJ9oNd17ezQV
BtM413IBPSBMpagfJ0XLmJL3EswRZgU7hBLHi9SDMjzFOAljDkhV4XGlIERV11OQ
cvp04OehJ40XtSLyLPPpZ2cP4tZK3VRa70wZUkUVyQlcWCcuoDimyCyQ38ml8ZOj
SeaMRQTOwpEIPL9Jkp+TG/hHJGNqf3muhvVIBx6iW2XFla5BCcxUZFhIQ3boLkDy
9GMX9Q2uC9X0zkjtRFkua81nKTIVabkgH4/EwiRNVz2pITMdENPUwMUJ2WNSkss9
nkOyGQGIqX9XM32a+1KcqZjnN7XYRE1D0zh+jb4FdTLX0HsIxxec4tieYr6QD5wr
PrgpuSQS6FEzh0i6CUwo5rrh0nkFekx6+BXhQougkiNN9gMPX8U3Ka8dUM0bgAuK
s8X9ugRGbcH6e1CpBBp3IlOoUF/Zl2mRy/yJmGFT0h3yir6Xq2YZSwYw9EXV4w0l
4sW4hbkWNbCnLkJhUQ88
=P7+S
-----END PGP SIGNATURE-----

--ben6AifVmj+t9BPa--
