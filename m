Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaAZXh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 18:37:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59803 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaAZXh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 18:37:56 -0500
Date: Sun, 26 Jan 2014 23:37:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, LM Sensors <lm-sensors@lm-sensors.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>
Message-ID: <20140126233703.GO11727@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
 <20140126211357.6fa68909@endymion.delvare>
 <52E573B6.9040903@roeck-us.net>
 <20140126214936.7736f530@endymion.delvare>
 <20140126212256.GK11727@sirena.org.uk>
 <52E580CE.8080100@roeck-us.net>
 <20140126215354.GL11727@sirena.org.uk>
 <52E585E8.4000100@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9rRS2CJFk/mxouRY"
Content-Disposition: inline
In-Reply-To: <52E585E8.4000100@roeck-us.net>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: lm90 driver no longer working on PCs in 3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9rRS2CJFk/mxouRY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 02:02:16PM -0800, Guenter Roeck wrote:
> On 01/26/2014 01:53 PM, Mark Brown wrote:

As previously mentioned please fix your mailer to word wrap at less than
80 columns.

> >Oh, magic.  Can you please file a bug with or otherwise talk to them
> >asking them to turn that off (or contribute code to make it work)?  Feel
> >free to add me as a CC when you do so.

> That means they would have to stop supporting anything that _does_
> need regulators, which doesn't make much sense to me.

> I think the bug is on your side, not theirs.

Regardless of how we deal with this with the code that Ubuntu actually
have in the kernel releases you highlighted has isn't intended to work
well with what they're doing.  Like I said in another mail ACPI telling
the regulator core that everything can be stubbed would be better but
with what's there right now my immediate recommendation would be to turn
off the config option since we know having it on can cause problems.  No
matter what we do in mainline it's not going to change already released
kernels and they can do this right now.

I'm open to surprise but I'm relatively confident that there aren't x86
systems running a mainline kernel without out of tree code that would be
affected (which would be required to set up supplies to do anything
useful).  Anything using dummy regulators only will get equivalent
behaviour by turning off the API completely.

--9rRS2CJFk/mxouRY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5ZwcAAoJELSic+t+oim9BE4P/R//4IXUiHio6Paw/VUVjoXC
g4c03SV1GMhcmhlX5fzFbMrOmr2m0GglbWxD09ftgKxgSHnKAfXcRE9bHaAsvRA8
t3AYlpiyq9ir8X6LNvWsCPkw9Qrm+DgxSHbHshCIZE/5nVTls6Ux1IEfl1iAI8wm
qx0kRTW6edcQeUkzSgWH6hYCE1UdMP46KV8MMtUE2OT83SiRexD2vq4gm74ty2K0
mBRxFjTMmbIQ+yn8KdFzVr39/qPi+Wuia56jG5tOLhFlK2wuYJCo41XG3P0YOTBX
XWEwHnATcev96GntelqzKmMwHSeLtIzIGRVTj8ZHzC40Cz+ncjzn0wuNNxV1ErRV
iZCKnTEvW02rFFJ2NDA925g96xZJjf03DHZv2bcH4/TFisbWPyt7Jmt4ddCCvvCI
A7n4IuFbm4jqzfuMYOFMjVqRsAi4QWkzCNgyxo4S6rP8ENTzMsz6UtRbAKMmmKvH
XFBa+HaJfgxcMTzVF7HWnMAOpuHq4WugR5xUG6ZtjvTzrC0TD65hcyxZUK0Jvu+Z
z8g19KkTowM9923H2JNTNKrMSbDu3V0rY1JtzrpJZ7C58wT3VfvH4ah0PMvlKG3q
VUjr1iUmQIswW/NKJkpn79z7Kf1hqav92KzH02kLfZldRJ8EpIHmTJ/sEySQGDuG
7U+ujhnMKBm82/kd3Hem
=8EQ+
-----END PGP SIGNATURE-----

--9rRS2CJFk/mxouRY--
