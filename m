Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3ISKpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:45:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46105 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3ISKpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:45:35 -0400
Date: Thu, 19 Sep 2013 11:45:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130919104525.GJ21013@sirena.org.uk>
References: <1379582286-10600-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m699nQIRt8EJjqXo"
Content-Disposition: inline
In-Reply-To: <1379582286-10600-1-git-send-email-treding@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: rt5640: Omit ACPI match table only if !ACPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m699nQIRt8EJjqXo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 19, 2013 at 11:18:06AM +0200, Thierry Reding wrote:
> The ACPI_PTR() macro evaluates to NULL if ACPI is disabled and hence the
> ACPI match table won't be used, causing the compiler to complain. Avoid
> this by protecting the table using an #ifdef CONFIG_ACPI.

Applied, thanks.  Like I was saying to Olof we really should be able to
do better than needing the ifdefs though.

--m699nQIRt8EJjqXo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOtXCAAoJELSic+t+oim9+NYP/2NNEJfIOoZT/HxrGBCCDCvK
/j66ilAUrCNDybecOekiRonjD5nD+HXEeC6MeYm/Jv58nwfi5Xe9WeZJZWSawM8W
4ai7tJT2ezBblNYMjKSSCeQ4llfTeUvPBxRQNEeqGhRbugk0FY0DfBHRhCLPvgbk
TaLY3lU3LCjFDZlPlnVHjaxcw0Rc0vGeH1X5pXmLGyrr/wctIbMsBBdmyMEO8B6j
hWL5XKgxsShBsfeP2G9km10hKBH8aTjtomXKrUpXbfp++DMAR2Iev9SqSFVtfW5r
Wq8N6R/9RTE9Pn5xmeoMDpO3Zk/qymPFqV+Zs7khV4ZIg+kZJG3Vc0ckC6k9vuC/
ijsiWBk2tFw4RX2Ntqt/3byk05/1+hTr41jUfSRZtPLSQkiNTbpmp6J3jhHk6vHH
mD73WQJY4mBaQDGZ/mcUUy56vCNcBFCHTf1Uje1UWqZ6/ZeWmzthyS8aLoC+natQ
DxxN3fFgPLbRfKgoo3nFoAZZugcxlki1PQCXhockv9O/1vf9oGk5JZXzyaAjyVoW
WWKzbkTAXPgnztFKgBSlGRl6cbcyJVmhZSrJ6y8mhmtQAZf1rJ4vtGQkz2sydZ5+
Twh0liYNagWJUlELDhPb284MLcos/urolynMb8sgNvrqmbnDppVjlykldW3yXmIJ
X3bn3HV7uT1z0Z0kmzDs
=yjk2
-----END PGP SIGNATURE-----

--m699nQIRt8EJjqXo--
