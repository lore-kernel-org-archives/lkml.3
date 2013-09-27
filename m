Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3I0QWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:22:20 -0400
Received: from sauhun.de ([89.238.76.85]:58597 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab3I0QWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:22:15 -0400
Date: Fri, 27 Sep 2013 18:22:12 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: i2c-dev: Create 'name' attribute automatically
Message-ID: <20130927162212.GA3094@katana>
References: <1380249371-32430-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <1380249371-32430-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2013 at 07:36:11PM -0700, Guenter Roeck wrote:
> The 'name' attribute is needed for all i2c-dev class devices, meaning
> it can be created automatically by pointing to it in the class data
> structure. This simplifies the code and reduces the probability for race
> conditions (the name attribute should exist by the time the device is
> announced to user space).
>=20
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied to for-next, thanks!


--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSRbC0AAoJEBQN5MwUoCm2vy4QAJx7ILRZ8udDN7DE3IzilGTJ
4PdDFojjBYh+2uwv2Eih3YKQZ+x5zQ8OrP3y8PznAmdOR5TABI5lubOk3e1QAATB
6hMXLryYe27q4WPRjiCw1PWHbxx0cD29XOfVEQu6q3Lz92QKiiKUXdikpii6+eXs
fC5ThyXxdUdwmjm4CNWGu5usDGRrYi0eO4jklM1O1jkKHJAnkXxDfRSBt+ZHMAnL
CBTPsRgcA9WBKllGRYLoVNejzp00vE0Nt+LpkTXTe0oBujiBxf0ElKRYJi3pdrbe
SoupflZcmv2//E5FTyPNWygyNTTD95W8e9Q44oVt6NA1djehp9r+FMYmL5CzCNnP
8gaQWcUby0LaY+Wj+GnwU75hUbazrBUBAn8+u6x+JCHGWeUXFHs3ioZBigsI/iCO
N6OQic8+RP+P1wm6MKsS+gaswgg1dNKQtS3ou3HJXcWXsaTZwYap/CxyXdp63138
8J/w4+dezRmUjl39GVl+3V1aEgMqd+IraOr1Vn3YBup1l9vP4N8/qNWELebktyp5
nIHqxM+6l80Qb0CCwORO71mn6Lv8+UHMbZfNhMmoEcla76UvxeIYkO9QHA35i2Fb
bQm0GvaHD9SGCAo+T8yxUz2n5TBdobzcfB01itzoZCNkzhsbJd95pykZpO+W1wTl
Pn2rndRX+XQxOfgDctsK
=EEFQ
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
