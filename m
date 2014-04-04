Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaDDANX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 20:13:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51127 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681AbaDDANU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 20:13:20 -0400
Message-ID: <1396570392.22689.90.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.5 71/71] ioat: fix tasklet tear down
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dan Williams <dan.j.williams@intel.com>
Date: Fri, 04 Apr 2014 01:13:12 +0100
In-Reply-To: <1396272197-13394-72-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
	 <1396272197-13394-72-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-a77gw+I5PysO1m9xcQ82"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a77gw+I5PysO1m9xcQ82
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-03-31 at 14:23 +0100, Luis Henriques wrote:
> 3.5.7.33 -stable review patch.  If anyone has any objections, please let =
me know.
>=20
> ------------------
>=20
> From: Ben Hutchings <ben@decadent.org.uk>
[...]

Should be From: Dan Williams <dan.j.williams@intel.com>

I think you must have got my name by applying the 3.2 review mail...

Ben.

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-a77gw+I5PysO1m9xcQ82
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUz35GOe/yOyVhhEJAQrjrRAAh5qCKUJm5Lup2qq/O/g06R9Iu0U2RAsx
tY0bJpglerFHvEgFULFF616o5aYKUAh532Hi1BUqy3UJDtTQJwU6BCsPjHPBjNP4
BcvRh66g0KD2cBjnv5fLVHeURPyVuEQOO/hl+itbMzTrvrnZIWZdmMroUuQit7di
AkMcFvvJFb/vpbhcbo5CUuHLXsFa2/MQHuRdVx+2nmvjlkgoLBxdf72pUcOrgBqv
AYbW68opbbQk1fVIrirErV55zGRNqp7tALajiqvJhEsyNxnKOaM651Xq/oBpNfw+
6QunKInJ/s+/jdpdtqds59zZlYX+zYRxn8XSVty7UgfCd2w8STLv93vs1A42Q90Y
x1TEVETSR1IK9cZJJAqA5syu0Yh+Y+bcmzPtr/+V8BLmPncSUN8F/BTYNvZdBaMX
L4ynaSavF+ErX6ytLLwJOlUVJ7rmqHmrPBVJjGzUVQQ8sbgaAItq7ksOIMuDZSLr
sP8v4lF3fKPNVX5p4LH3AX3H6dLvUVfya2liMcQQa+jFKFLGU9sIUfSIQpgjMpdG
ylAWBrQRoh+oi9Uj6MnANzXe6wU0s3d/t442JqoyyGZf3ofHmA8atYK1J+IN0I33
5rUQAcmHopMQsLc1kUNPjNONjuka8PvtUHbywril7XqGcDvTf0h/jrh4+Z31fvxS
EhcWXFEsSpI=
=Hqvn
-----END PGP SIGNATURE-----

--=-a77gw+I5PysO1m9xcQ82--
