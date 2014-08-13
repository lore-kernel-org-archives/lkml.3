Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaHMIH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:07:58 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64531 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaHMIHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:07:49 -0400
Date: Wed, 13 Aug 2014 10:07:45 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/3] Thermal reset support in PMC
Message-ID: <20140813080744.GD7735@ulmo>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Content-Disposition: inline
In-Reply-To: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EY/WZ/HvNxOox07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 05, 2014 at 11:12:57AM +0300, Mikko Perttunen wrote:
> Hi,
>=20
> this series adds support for hardware-triggered thermal reset to the PMC
> driver. Namely, it adds device tree properties for specifying the I2C
> command to be sent when thermtrip is triggered. It is to be noted
> that thermtrip won't be ever triggered without a soctherm driver to
> calibrate the sensors, but I'll follow up with that patch.
>=20
> pmc.c required some juggling around to make the match data usable in
> probe, since I didn't want to put the code into the initcall either, since
> the soctherm driver won't be initialized by that point anyway.
>=20
> Series tested on Jetson-TK1. Should work on Tegra30 and Tegra114 too.

Can you describe the procedure used to test this? We currently have a
bunch of features in Tegra that some people have tested at some point
during development but the test procedures never got documented. That
means whenever we want to test something we need to go and reinvent a
bunch of tests after the fact.

So what I'd like to start doing is collect tests (preferably in some
scripted way) so that they can be kept in a repository that people can
easily clone and run on devices.

Could you provide something like that for thermtrip?

Thierry

--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6xzQAAoJEN0jrNd/PrOhGlMP/RDY3Q6BSFROV0YugQfbLzzI
njMk/o+n9NfNbFOvXNtzwNe3saKVCotTaxaDdAMJel2EbKPJF9KlThoc3P0rIEgI
O35ESQqInarG81I7Q1zeJqWwP+szSOP2e2BCgcj5tOW2MRm8wdaKJyJQWtHSYHzq
B0quaw0rIn2//kMzUq/hB+bPDQsrZ6VinQ2h+HRoC6y9qqFklI13Ulsbo2aYYOeF
ul4D7KbF3uyzvlWLWXwEzS01MWhKLyAUY0LcSMMLV42JTsqzxFnIpfnlRVM1u0Fz
9zLc0QIC1KNyt980YbRRV4UWpOxeHVozZdt+lEZCupGJuZ2KeJ5y7egx4jCTfJdU
vf2xydVUt5ASYiv2VwgAq+G0qczWzGEdpPvHnze7NE0zpBs96vUOmE9VWlUNmA7K
ANCGsdOAOZPWQc+4mOvcWk4K39fzvKlEeVAqIx99f89gGp5pklmR8LQQVK3bjOiw
FsF2tqh2HbLiXSQZU6HhIW4Infyqj0BAHDRiITbSYtJfmXl9L2zSZjh4ebHW0Etl
Zbdn69QJJI8pph3/llhOGtZGvyQPdsxkXTunnR+n+U7f9LWj1NJjRfCY4ibMhn6i
6Zec+ELmfDLcVWlfU28bWaJZZGdOqzCbNjA1TiE4f7Cw30PHdLJWVf7ex8BuJWG9
2V0Lx2FyTrGJ+cMjpomN
=PJrc
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--
