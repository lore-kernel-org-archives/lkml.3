Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaF3VoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:44:02 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42058 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaF3Vny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:43:54 -0400
Date: Mon, 30 Jun 2014 22:43:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Dan Murphy <dmurphy@ti.com>,
        "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <20140630214342.GI23300@sirena.org.uk>
References: <1404148259-17305-1-git-send-email-dmurphy@ti.com>
 <20140630172115.GE28740@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5zn77Mes2TPnoMqf"
Content-Disposition: inline
In-Reply-To: <20140630172115.GE28740@leverpostej>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: tas2552: Support TI TAS2552 Amplifier
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5zn77Mes2TPnoMqf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 30, 2014 at 06:21:15PM +0100, Mark Rutland wrote:
> On Mon, Jun 30, 2014 at 06:10:59PM +0100, Dan Murphy wrote:

> > +Optional properties:

> > +- power-gpio - gpio pin to enable/disable the device

> The code below seems to look for "enable-gpio". Searching for
> "power-gpio" only hits in the line above and the example below. I assume
> the code is in error?

It depends what this is for - if it's for an external regulator it
should be a regulator binding.  Also all GPIO properties
are supposed to be called -gpios because DT conventions.

--5zn77Mes2TPnoMqf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTsdoKAAoJELSic+t+oim9QYYP/25XMOhM1tgeLLHbHKljr2wm
NP1g6gvK7C7vE20dQXB4GP338bEIddOsr1tAmJz/u5S1undyVhYfN7pOmiPCJsdX
9HcMYsrLKmlGtlCX0Jy4ECmEMiFP9cJ5EW03LcdAAx92Go9xqprOCA9YhFGjUaB5
jVwuuhHnMAShFikW4axpknihUU89DDNJ28Rw4oocb91LhdJG4Y5au5f3rNug9kMC
jfxd4q5vZOZoP7o+WSn7MJceas8wmTWaFyRvboX0uu3gaY3lDobEQwdJ6ASg+gQL
Yvq9LRAMNuWLacXwrz9N8xJLKNI6/FHxF3xHqOzSsgxjaoDB0pgVMgHeSA6SjNbB
1VDb2hVVc4acT8ngGtmFoq93pwLZ7rmkVGTosJQ5KWT7Vqo4l5TWsVQxtRLvVBq9
BOYZoV6L2UdBkITSXnvpEKEH3Jqn3w2ca3SHt/Cqm45NYRm9zjqySfU/Zqbq+oBS
7BUgYrJ5UyuzTS5fJV2LQNasFnTFchRDxum3/ko8nWYSVDlcpfw5k1LJbDYuwOWj
3UgF47kMcF1iAaBrIy8CB6e+Dj76KY6zVINxgPX5jM2ZTnzZ7rVdoJlJDRNPtDvA
2pykkvMkYPaydMXpnn1Kj2OUF0AKtB7oHqn9hLOehefFNanLkaKbtth707Q0bTim
iGdxKMrrPYzxeO40Ku7s
=Nq8+
-----END PGP SIGNATURE-----

--5zn77Mes2TPnoMqf--
