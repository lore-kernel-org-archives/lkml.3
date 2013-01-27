Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab3A0GNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:13:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47830 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755727Ab3A0GNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:13:54 -0500
Date: Sun, 27 Jan 2013 14:13:39 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] lp8788-ldo: use ena_pin of regulator-core for
 external control
Message-ID: <20130127061337.GD8952@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E12B45@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E12B45@DQHE02.ent.ti.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BRE3mIcgqKzpedwo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 15, 2013 at 04:35:53AM +0000, Kim, Milo wrote:
>  Regulator core driver provides enable GPIO control for enabling/disabling a
>  regulator. Now, enable GPIO is shared among regulators.
>  Use this internal working, so unnecessary code are removed.
>  GPIO enable pin configurations are added in digital LDO and analog LDO drivers.

Looks good.

--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBMVmAAoJELSic+t+oim9M+oP/1f1bng/x76fqFqGKfKKqkPL
TCQgEqn+HVxvsSfSYg6g26cf1uB8Ez3l4uM619FEmZsX332LHWgwdhXoGcZ2jl4E
ycHCv22XtWRjPGVVszhG3V8ZtaRGARQpvxtl40QgTO44/rhW9Zta7fnVrQ0CCYZW
x7KbrZlcj9KCSrp3RW1iHRd551m7TLVI6g9LGYafDHhZje17wMwDlpwP7MEG5STS
Fho/kGybJ8/VwTBV1Pa6HE9nH9QBVc7PhsY3A75eOAI+aTqlMxD4RUlWmJo2Aktq
axDF5DPoWesKEeeP9XZeoVPI7qjkKxatr3cr5iPgWOppzWYZ9EbKlWIiY4wmzOvL
ezLUdF+fz4VbhQnd5txPnmGGORr1+CY0bts1zXK72o4IW/nqN7Cxj9VNcVn9ZWuP
eVUJRpwagaVYVHcruwfwYm2mKWsjaw8nY5KY6AriXHbZZSoMxLGvKrV6utWpD7nG
DhHy/4PRCFIldu4yZMZmcgpumDrjfB5SCHYOopEQtGUJBEL0zRq9SZJMiDRV6JCE
SGeU58pOOhRFfwXIudRQdmWtr5S0t1aOhuhLPopv3FfipnCo60VKBc+4jOQfPXEN
ilOuTQaYPMgW0CgFhyzKjZ8zUnjH27UQduGd1v7+V8/jRbui0HJjBTv1o7dNJ5Ww
V4URjWyaHDNEG/InypUZ
=a8xO
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--
