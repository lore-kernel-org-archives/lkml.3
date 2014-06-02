Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaFBM4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:56:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50872 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaFBM4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:56:24 -0400
Date: Mon, 2 Jun 2014 13:50:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Tim Kryger <tim.kryger@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>
Message-ID: <20140602125055.GE31751@sirena.org.uk>
References: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
 <CAD7vxxKT+Wq2ArH9iYLm2OUeBSqKvzORKZ1NnoyPcdcDH6wOKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wchHw8dVAp53YPj8"
Content-Disposition: inline
In-Reply-To: <CAD7vxxKT+Wq2ArH9iYLm2OUeBSqKvzORKZ1NnoyPcdcDH6wOKw@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.174
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulator: bcm590xx: remove unnecessary OOM messages
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wchHw8dVAp53YPj8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 12:12:20AM -0700, Tim Kryger wrote:

> The probe method of this driver, on the other hand, performs several
> allocations and the error messages you intend to remove conveniently
> pinpoint which one failed.  While the offsets in the trace could be
> used to derive the same information, I am skeptical that is enough to
> justify removing the messages.

On the other hand how likely is anyone to care which particular
allocation triggered the OOM?

--wchHw8dVAp53YPj8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjHMsAAoJELSic+t+oim98tMP/iVRXlV+1VKf0Qh9cS77S0RG
NJFy90iG5KVOXMbr06ILC7ByTmDkTHmNxXw/1+Hl+GPb2AGxHJws3GyQxP9mSyBT
jTjxxexDcX5MwyYGJcYfVlqCx+In2CjkvuDZSwwkTgZ69FjK8E2GwzhecUc4t9OK
Eg1/IYHTp2QA91i723DuaSB+swRiPre5R2Irwl2uHmSOTYFy84RqoWNSSRwPBXWr
KtjIyXweyrX249OkI8N5+WvOzNB2ykdz1Wu96yj+S05YJXC4u9f39jOqkx6WqJHj
gcWIcjhd40J5ew1KRmWL8p2hMRWBCHmhd2H1hhbaUsjg4UeyKW8gtGQRNl9VwO/Y
9Zs/tG0i0TrvZf/bfj8gK6ZymcUSnRxHRDH25JvZ1MMmPYpt87XQfztGsp1kRc2J
H1akTq5J9ARd592ngzKb3QiRdMUbjOIa35q4eR7wfH70RtLx2ZfM+Rh3+oiXlDlE
bdz72lOUEWzns0RYuEJdKVCpuad4wc8DUBttZ/QMgZxeOT8IMp+N6g2scbg6ojip
M9VCJaAaYM0lcvfPKaFP7vgneL93J+L7GnLpdtabXoK0MCK4U6nCO14moAB1wLzA
Ln0xXABm+93+onfFktSi1DDNkHQz4XWXzkQyUrFz5bU5PIqUipHXHlVN8Bcn2ye+
2RYBkhZws74odVShKrim
=LagZ
-----END PGP SIGNATURE-----

--wchHw8dVAp53YPj8--
