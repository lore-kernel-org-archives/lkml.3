Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbbAVCYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:24:44 -0500
Received: from mail.kernel.org ([198.145.29.136]:48800 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbbAVCYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:24:37 -0500
Date: Thu, 22 Jan 2015 03:24:27 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org
Subject: Re: [PATCH] Add LTC2941/LTC2943 Battery Gauge Driver
Message-ID: <20150122022426.GP13715@earth.universe>
References: <20141027163842.GB20765@earth.universe>
 <1414479912-3545-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fjEAjMKpll6GDq3U"
Content-Disposition: inline
In-Reply-To: <1414479912-3545-1-git-send-email-mike.looijmans@topic.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fjEAjMKpll6GDq3U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 28, 2014 at 08:05:12AM +0100, Mike Looijmans wrote:
> Both the LTC2941 and LTC2943 measure battery capacity.
> The LTC2943 is compatible with the LTC2941, it adds voltage and
> temperature monitoring, and uses a slightly different conversion
> formula for the charge counter.
>=20
> To avoid confusion with e.g. the LTC2945, the driver is called
> LTC2941 instead of LTC294X.

Applied with .owner field removed.

-- Sebastian

--fjEAjMKpll6GDq3U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUwF9RAAoJENju1/PIO/qa2NcP/2uJ/ZkUU9bdeoiGSTMZJM20
fZJfmQlHjUFa7OhgsqocVO5O4upl5PdSEZC5xFNRYOW2yDGbggWlnGw1y111oo7f
JIe9hqXvt/urX24gd4QAjDxIZfjQ7xiWwKH1mJE0egZ9/k89/tOZR00TN/aEMJ1e
9rmZ3S5sASEq63V5fjLrDkoPuTjLQdRGgUcGoJoUNzBEzylATcD43Vo6hzi1b0oN
jt23vsKfnHG7dKuqAhZIzmwo3n1PAqeFdvrmxf8jkq4iUEeEh5BBjZ90Vo+jQWdh
uv/jHLrob6ETRlOpmqKsTpKfF/RIKRAUIDm+ED9BpxpCS098MHF8bqCUcb1Ci5ug
9fZoqINxTa8gq44gzTE45S5ih+KPX4BANPzg3r70o3yJP8anKbURqTszRW4+TOnD
Mavh1YyM+jPYPra9ZJNzunyEQKsF9/lT57Q7kRU4BgBXl+1m23GcwDUFAE5uLncY
vvVtMY4mvbtS/wuphFGzEfV9S62q91SSGLrQcoqPTxY+37UhmarSSJ63aDANO4AY
aTlsGnLHkYhPVMk/o+j/+XInuTvH7XgwZjRXdVegBAejYKdpjCg5McO+vpY2Nlfb
IyU+JHEgHxuI1xCI04jwuCWsx9WVLOXUEGLx2tw0A0WZcoM1ekQqzRoe39XsDFfG
+IW7ZAycuCu8ap8GpM0B
=5mh1
-----END PGP SIGNATURE-----

--fjEAjMKpll6GDq3U--
