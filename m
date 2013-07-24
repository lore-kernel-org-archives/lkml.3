Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3GXPau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:30:50 -0400
Received: from sauhun.de ([89.238.76.85]:59055 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab3GXPaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:30:21 -0400
Date: Wed, 24 Jul 2013 17:30:16 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-rpi-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH 17/27] drivers/spi: don't check resource with
 devm_ioremap_resource
Message-ID: <20130724153016.GB3016@katana>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
 <1374602524-3398-18-git-send-email-wsa@the-dreams.de>
 <20130724142940.GC9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <20130724142940.GC9858@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2013 at 03:29:40PM +0100, Mark Brown wrote:
> On Tue, Jul 23, 2013 at 08:01:50PM +0200, Wolfram Sang wrote:
> > devm_ioremap_resource does sanity checks on the given resource. No need=
 to
> > duplicate this in the driver.
>=20
> Applied, thanks.  With all these it'd be good to have subject lines
> matching up with the standards for the subsystem.

OK. Let's see if I can script that :)


--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR7/MIAAoJEBQN5MwUoCm2iiIQAJOMA2/AMu6mr5J/SBZd4XzM
4ZH5zQMa8muN0gLt3o+ck63fnPScPJW0HOyoEipkX55RoAJURSHjJFjdPCnm0zw9
n07Jn42BjRzOWz3mA1++ipgqjBitZLMUzT+S+ldiSxAyiEWkeMSTlFmF9slYW4Tr
nlivQLwdJC5y1dfZAFotbaM9429jVBlbN8yPd5nqn8K9KQ35eLDCm3jX9K5u0+qz
GTU1PsW8h/Jgrrhg470fuSAhC6DMEz3xvkai96JN/az9szBziWQyiRZp0GO19Heq
Hnkr56JCd5uh8mLmsRWrAnglLAh3SY/v6zEjkUlyBXT22fynKvfHf4S7y3P+j6F9
cQJv0Y82XJKoVu4GMJ8Mvhx44XHcEbN7XByjq3C+/PLnqa8EMRcp82Nx0+w9yNnl
Fw0is94Fi1kG1UupODVFto11QhO/R8+vjxbYATNpKRUAgyiyojQxAT4I2Q5QIh0D
ZX7hI7QmnmFqEbBJq03x/HMkfkQsCkvDhMbBxumpRMgi5w1IFjMHcc7pI+1DliYG
6rRo1+GoEPS/p90Oj593SZYVvGZN7UliJYoEIpbWpU/Tpu/zewhBfBxcnaKW7+MM
j62af+4zE0mhPuYs2AdDyhW/SDqTq2w4M2H5y2DhTI1WmJ0ybiVj0YiE8R9uCFfD
De3/tF7mvoKeTg7xDe0x
=qn9r
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
