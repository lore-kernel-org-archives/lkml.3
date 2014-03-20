Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaCTKCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:02:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44379 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaCTKCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:02:51 -0400
Date: Thu, 20 Mar 2014 10:02:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Shuah Khan <shuah.kh@samsung.com>, lgirdwood@gmail.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Message-ID: <20140320100241.GB11706@sirena.org.uk>
References: <1394054987-4743-1-git-send-email-shuah.kh@samsung.com>
 <20140319235828.GC22080@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZVHwZItCpgidUOc6"
Content-Disposition: inline
In-Reply-To: <20140319235828.GC22080@kroah.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3.13] regulator: core: Change dummy supplies error
 message to a warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZVHwZItCpgidUOc6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 19, 2014 at 11:58:28PM +0000, Greg KH wrote:
> On Wed, Mar 05, 2014 at 02:29:47PM -0700, Shuah Khan wrote:

> > -		dev_err(dev, "dummy supplies not allowed\n");
> > +		dev_warn(dev, "dummy supplies not allowed\n");

> This really isn't a problem that warrents a stable backport, sorry.  I
> can understand distros being "annoyed" at it, but probably not.

A previous stable commit caused this to happen for esentially every
regulator request on x86 when previously it wouldn't have triggered.

--ZVHwZItCpgidUOc6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKry+AAoJELSic+t+oim9QZMP/3nAXW3yEVzyJlW0gz/WYta+
LlQIgsU+UNCGEsSlkBxHy1G7KOWUMjV0joNMwIM1o0tAO6vVnQ64zMi3eq56Wyf4
LsDfZogQ/P18weTSGLLdD7cZ0Y92Kadq14JmpYjhYzs3wJ1FyCWCi6wzdoxAGyyB
4bla3OQYU7Ngzu7i8AAD79dAvPWC3jLZCSPJ3x+PsDUX7Ay6wxxoP5t+ywZcLIWp
80NTCt00NOOTZukO/EtALifciUfwdL36/3PfeDi/3872Wlz21A9HHvDmED5AKaEU
kjq8Kq5/U3I1FsTIrTAMfbcisRGmlKMkiK6bgR/5WuAP7UxWnpeFsat3i0qKiIHE
4QHB2P5Fpe9o+PUdlCXttFYXkUvlpBnPWK5V+A9dur7SYUQMXouKvsmSOIvXz40e
Ww5f2fsbkwEIT9KhD3s7XOqZ6fwPSDWGo8KoKqu/yU0hCaOGLAazEMYheqovQ46c
wm5cEe0M1aF9uCTSo93bXOv5neEggEMrWzk71jBU6rgEVatO2Fi0keh9tt5g/O9W
AoGjpQgFyvGcZsdPb/EUzp0O7/yrTf5fXK++4niMqo1nVPAQHoRxajmadctlSTw4
nvOYm28ihoSIP1UyEjkVPKDtLr7xGAcRMxgv3CeRau8PIdeyDriYU+h7/etA28Rc
KPQFNGqVHnmn2WV9Jjbx
=RgBa
-----END PGP SIGNATURE-----

--ZVHwZItCpgidUOc6--
