Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750832AbaABBCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 20:02:21 -0500
Received: from ring0.de ([91.143.88.219]:59013 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaABBCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 20:02:18 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 2 Jan 2014 02:01:52 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Florian Vaussard <florian.vaussard@epfl.ch>,
        Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, iommu@lists.linux-foundation.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/7] iommu/omap: Convert to devicetree
Message-ID: <20140102010150.GA9933@earth.universe>
Mail-Followup-To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Florian Vaussard <florian.vaussard@epfl.ch>,
	Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
	=?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
	Grant Likely <grant.likely@linaro.org>,
	Hiroshi Doyu <hdoyu@nvidia.com>, iommu@lists.linux-foundation.org,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
 <1387284818-28739-4-git-send-email-florian.vaussard@epfl.ch>
 <1764051.JiGg1d3s1L@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <1764051.JiGg1d3s1L@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 02, 2014 at 01:13:42AM +0100, Laurent Pinchart wrote:
> > +		.of_match_table =3D omap_iommu_of_match,
>=20
> If CONFIG_OF isn't defined (pretty unlikely I agree, but a possibility yo=
u=20
> seem to be prepared for nonetheless given the above #if), this will fail =
to=20
> compile.

FYI: This is avoided in other drivers by using
of_match_ptr(omap_iommu_of_match), which is replaced with NULL by
the preprocessor if CONFIG_OF is not defined.

-- Sebastian

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSxLp9AAoJENju1/PIO/qa8TMQAJyNOJApiYO7fM7mlYaWa7hZ
YQOdv3vPoDfgOBakYlaDcVomeAHfl/LvFYCH5aWpR26EE25v9+NvNzFv8uQJdkkI
ZSjrbGprU6Tdv174XkuQNYSZm4APOHbdke8fQjB0nw5UlHGefqkh3Sen1EQHmsHC
NH8f4ssoXGgMuHxMPRwo29XV28Ms+BsPBBwYZ5An0caAQaI3O9DSaWbyBfI8Bz2T
St2kRa0kcxeARR7sAO1hd45wCulnPXN/X9vR7Tb8n70UIq04RMw9xrJzoEGTtW+L
8H4aazq0cNjpSs/pTmcjRVbA1ezta2peoh7cpRMcwjwCLYeN3VS46vRJzpJAfRVC
oath3JxYOzwwpdtXYWR+53x6Enu4r61DP6hgIBtTek/n+svsIC0PNVvusjnNbrle
lGzDS3/wV/qhYZnd6YT3xUlHcXoFfo1P10uahNNc286eCA5OSb141KYPLturuSw0
lMkHTIuYyomb+FqiR0zuAKytcF6hte49N09I6rKvQWEwZPnfLmiiYZLz//BGfLbE
iJ8vDCcEZ9sJ6d56NDMUg0Od/NQz0H6IdwrLQczSpLo4Aw+dNY/jdK8yMBv8Ploj
ebMGJV/YxmMizy5Vn+45spNw4cS742+FuzM7INkI0+rmrEqsE0hb9ytdEeT3l760
jWBNdGZBqgbiPBrbZS1X
=/DGs
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
