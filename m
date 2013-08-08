Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966266Ab3HHT2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:28:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55101 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966205Ab3HHT2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:28:09 -0400
Date: Thu, 8 Aug 2013 20:27:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Wei Ni <wni@nvidia.com>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-tegra@vger.kernel.org, MLongnecker@nvidia.com,
        khali@linux-fr.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130808192747.GM6427@sirena.org.uk>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <1375944991-29182-2-git-send-email-wni@nvidia.com>
 <520359E9.1000600@roeck-us.net>
 <5203D5B6.3060806@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8d7KAgWmJ23Ts4y"
Content-Disposition: inline
In-Reply-To: <5203D5B6.3060806@wwwdotorg.org>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8d7KAgWmJ23Ts4y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 08, 2013 at 11:30:30AM -0600, Stephen Warren wrote:
> On 08/08/2013 02:42 AM, Guenter Roeck wrote:

> > If the regulator subsystem is not configured, you especially don't need
> > or want
> > to pollute the log with an error message.

> DT parsing errors should be reported. However, if there's nothing to
> parse, it's not an error.

> So, I think this should report an error message *if* there is a DT
> property that defines the regulator to use. If there's no property, just
> use no regulator. If there is a property, it had better be possible to
> parse it.

On a DT system you should get this behaviour simply by paying attention
to the error code from the regualtor API - the core should complain
loudly if the DT is incomprehensible.

--n8d7KAgWmJ23Ts4y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSA/EwAAoJELSic+t+oim9TR4P/37WBWSfsgZOLTVV5ZTrSRrS
+o1DaSk7HykNQZhG3a+uNJwYeUnt05jOrpIDVXXPphCZoWx7PEdPy834fY0PuBku
vbbNJnu7l5dTSORL9EonPhkeVTxcsVKCb0GGihvFFqtB+R/suZRZkUvdySJ5+V82
BuihUkXnZakLrTEgSrjBwY8E/3fYzQYZAVbnJ6cIzm0LFYYduqjMmM4Mjty2zlHr
z+60/KzSNAkE+lu6Dt+INgssF1JPKzsRrKdX3K8rFVHzmVE2bVuHdkLItTxYs680
PPyyYv5Cd4ch/trTXxjY3l1woe6edgEVDiLN1x6EHHcGeEm/M/sR+9DwjBkQIT+z
fSb+GJZCZO03LIILmHKWLrwicR+4J3Dx2WtDoZFmUj62uQfhDPfxs9QxuLye3JR6
jx1klB1fXp3PlqZsC6Mh30E5bajUtVpkTkt2cLMkfDNgUi4y8dPUDO0APk8da3pM
lv31J0EmmxpvQa41TaQ68d5UWOeat0TZ3+tW7wfHvhSISeb8vZeKCBTFN7LQELxq
yrOR2MA8RBY5pJCHBpSJfPp3n3iqGkehQUTaeZvzNCkbFJE7m+C7T9kwAsF0Bgmo
GcEt6H473uXr1tNH+8bXYx0VCeBpjZkB35UZ9Rh6n2g6UoLN+TgKlyRLpfu2QrVL
F5MHmPNfOW+rHMpjOKZM
=rZ0d
-----END PGP SIGNATURE-----

--n8d7KAgWmJ23Ts4y--
