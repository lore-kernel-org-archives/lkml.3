Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3ITJua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:50:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47518 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3ITJu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:50:28 -0400
Date: Fri, 20 Sep 2013 10:49:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130920094959.GK21013@sirena.org.uk>
References: <1379650535-17223-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dbdikjxO6Hyl7qA/"
Content-Disposition: inline
In-Reply-To: <1379650535-17223-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: tps6524x: Remove redundant spi_set_drvdata
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dbdikjxO6Hyl7qA/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 20, 2013 at 09:45:35AM +0530, Sachin Kamat wrote:
> Driver core sets driver data to NULL upon failure or remove.

Applied, thanks.

--dbdikjxO6Hyl7qA/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSPBo+AAoJELSic+t+oim92ucP/3JnYPwFozwlpbY80YQp6WIB
dEowfCIzAt+Rfebje1r43GRcs+kRCp0aHNUrb++os0YnrVLpAdaBSRQdUT+ZOWfQ
LkBr6+LdNS1Ieds7zch96EURDQkEuWw5Qw6py/vjnzZaYkmUApVKyTK+wJK3KwYo
7adfJX6RMDaqQTK1VENsoGSgFZ70p8EW99XbqdZQKOeiE03XAp73VdK6lRYiX0la
nfLtixjA8NysijDhQ/1fVMfoUdvqzK0D1UQkM603tSgV+RsTraSyfuzxz1TElmtH
d7EpTYOVkxf1Sa4F9kYAFJSztcvPsbuEo7nKwD1KCA14/76b7uH/VmCCxsyudTDq
1rCwVhbHo46AM1m5j86PQGIMeB87rBLXi7B1Ott0QOGo+yl7s43aaEHskDfybJpX
66M+JRJkVc9U+IlZ56wa7fP4xgxLAzdYl/wSR9Bb8FWRlGCnJsQfRW1KPCj5euWZ
Zpw3r/On3ZKh3eKmtQMGzlf1V0H4/cS03sLckVHoyyGHJQ1ywdZ5YAwWYdMG+35D
3s6r1VLPGbaTRwv+OlQxyayNZR+AilyMhxqJjXqxrZt3otRdiE4xiBOA5MJV0WXl
oypxM7Haz5G/naXwjcflNxLE/ZKhm6wXMRjWiK2P0jcFm90/e8n15FH0yB8pSm6N
pd3g4LNAoJGKHz6hMgxZ
=mfgP
-----END PGP SIGNATURE-----

--dbdikjxO6Hyl7qA/--
