Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3DWKsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:48:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36836 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab3DWKsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:48:10 -0400
Date: Tue, 23 Apr 2013 11:48:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFT][PATCH 1/2] regulator: tps80031: Fix LDO2 track mode for
 TPS80031 or TPS80032-ES1.0
Message-ID: <20130423104808.GJ5019@opensource.wolfsonmicro.com>
References: <1366206143.3305.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/0U0QBNx7JIUZLHm"
Content-Disposition: inline
In-Reply-To: <1366206143.3305.4.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/0U0QBNx7JIUZLHm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 17, 2013 at 09:42:23PM +0800, Axel Lin wrote:
> Currently we have a special code in tps80031_ldo_set_voltage_sel() to handle
> LDO2 track mode for TPS80031 or TPS80032-ES1.0. The purpose is to address below
> issues:

Applied, thanks.

--/0U0QBNx7JIUZLHm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdmbiAAoJELSic+t+oim9It0P/2o49SKxXaJJn0aF5MRi8E2f
AFz+wEi9kYT5CwH4YYreXLpXj2kn7z/K41n8y2uCywemjs6z9vXuY78Arz8kQQMy
Z+IdNPuwi1T59CmSKj/R1I8OOZpqZzSZ3Cf+iAVDtiu+oG+fWR2YbRrXN/O4u5pV
6PGThUG5AU0A2i9q22101cMXKMo2C4wAy8zLI/0bh1xdwzubw1DeC4hbrHUkUtnW
jlHue9R1JuZQ7ZNGH+gajI3jMSk+FQWAoCiK4MBpOiQfHCemg+IyQVYFptyPdEPV
Qj65XYSkx0oCCsOAQfM07TLntPY5wIebTqsoWwru0ChTUXfrvMcqSQZFrL9uLYzi
qzuWa6GP1YQfA0CHjFpDREUNElWLabB6Pa446B/KSxjgeVufAw8H9fAW0qp0v0aT
EjxEZn/rF0faBX0v/ErECJBBzjQ+1w4+M/kGamReqS434LklxBpdM88c0NnEXThz
BnenTPXGEv6JMereC0NZjMx0s8EyAA54HFV6GQ52nEkkJNuTu+6iY9qc+mUltriJ
/Nb871Bu1BeYQmkHdP153cBMDN5ZSfgwiNS01RCsPr4ZDJm6gm4JBzgjySxidj8W
7VZj2uW+UZG2NYwHuqSphMCMqWDxN4tzY6WIt/4ZTQoX6FWlENkeHdEn7a5f656y
QN3WGhjf7yHpwdjipJ9n
=3/SD
-----END PGP SIGNATURE-----

--/0U0QBNx7JIUZLHm--
