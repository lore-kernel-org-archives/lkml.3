Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3IKLOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:14:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59188 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3IKLON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:14:13 -0400
Date: Wed, 11 Sep 2013 12:14:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, linux-arm-kernel@lists.infradead.org
Message-ID: <20130911111409.GO29403@sirena.org.uk>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com>
 <3397524.g9aUWuArnm@vostro.rjw.lan>
 <20130910213522.GG29403@sirena.org.uk>
 <2029393.u6DaKBPszu@vostro.rjw.lan>
 <522FC0DC.9030708@intel.com>
 <20130911095552.GI29403@sirena.org.uk>
 <20130911110543.GA7393@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zdA3Jw0ChSeS2+06"
Content-Disposition: inline
In-Reply-To: <20130911110543.GA7393@intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C
 client devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zdA3Jw0ChSeS2+06
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 11, 2013 at 02:05:43PM +0300, Mika Westerberg wrote:

> I'll also look into converting the existing I2C client drivers to use this
> method. One question, though, is it better to have the conversion in the
> same patch that introduces the I2C core runtime PM change or as a separate
> patch?

In theory it ought to be part of the same patch but in practice a brief
bit of bisection breakage on a single branch is probably worth the ease
of review from my point of view, others may disagree though.  Like I say
I think you'll need to convert SPI at the same time due to the devices
with both buses sharing code.

--zdA3Jw0ChSeS2+06
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMFB+AAoJELSic+t+oim9oqQP+wX1XDd4XEIDpvVbASnF3UtL
sIvZYgKbCzQt43LxmC+16h/gXNlGryWbnbtS3avYbMUHq7xEzbthFilXxO9WK3UL
8XPb0Mh9XTP7vi1m3t6N2nmuiQyWJAUeiLgFVQI6RJQVdUZKsS5dJGG9aN8CdlNh
OpV/uYpgaGRM+zusKngBb6e1jFzCufNuC9xjIQoT5xxjKNwG756tRWDX1ksFuKmZ
+LDTg3kNsk4mg8jS7RjVkmw8OKBXGlZxkjKeq+KdjXTzKh4YyJGiF7bEJJQdDd87
7qkV4IRi3O4cJ/WHaliesgd+rW4d0NN0cqzy69+6gga/+9RvI3E+x7U0cOdS0xZV
Ut+AgIlsAJYi0Oy6ZeuwZqDj8oHTDTCq2c8f+jdJzzDE9tAq7yksgKXTChgRLk26
g8W/h0EhOCpTaS6Co2AERgdvSEYpB1rfgPAzhnGdAM9OGbnvvuOESyLkUgMjJifj
NCzZR1J6RVEm2WKJfCEoHKo1PdgFoiNJpjqhhFUY7skXJGikarrXJAUDv9eLr0mA
olPorDkgql64tr/0efrpd31gsZeNihMQ48AAWDyQcI7jk/XDZedUoJRTtTur3SWZ
G62yWn/EpyZAK+Jvln/bJjBNWPim8fbzoPx+70/oberWkCCbdK5GfYMaAirpDIMO
0MBqhfFlqSalVI2mEG4F
=TwXJ
-----END PGP SIGNATURE-----

--zdA3Jw0ChSeS2+06--
