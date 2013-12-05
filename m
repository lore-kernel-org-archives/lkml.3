Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab3LELf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:35:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37560 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3LELfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:35:54 -0500
Date: Thu, 5 Dec 2013 11:35:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20131205113531.GN29268@sirena.org.uk>
References: <1386203515-6815-1-git-send-email-broonie@kernel.org>
 <1766701.HGqKkTj0sM@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7trrzIZ+323l9a6P"
Content-Disposition: inline
In-Reply-To: <1766701.HGqKkTj0sM@avalon>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: gpio: Don't require a regulator-type property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7trrzIZ+323l9a6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 05, 2013 at 01:44:42AM +0100, Laurent Pinchart wrote:
> On Thursday 05 December 2013 00:31:55 Mark Brown wrote:

> > +	if (ret >= 0) {
> > +		if (!strncmp("voltage", regtype, 7))
> > +			config->type = REGULATOR_VOLTAGE;
> > +		else if (!strncmp("current", regtype, 7))
> > +			config->type = REGULATOR_CURRENT;

> Should we warn or error in case of an unsupported value ?

That's sensible, yes - this was just a straight change to make the
property optional.  Given that we've always accepted anything a warning
seems more appropriate otherwise we might break existing DTs with typos
or something.

--7trrzIZ+323l9a6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoGUAAAoJELSic+t+oim9yJ8P/ii7ElNMdvjRx8elVGlVTWly
yCD7iADLChd7UA3rMk53mUCusOcCSefdOT/N9dns141ikg1FGgyXBz9wpDpLxlSL
UONaNyIK6idKQeCPVNTVBf6dBredEY0Dwimqlqs0ZQS4lxnCmj2f7HDHNrTf78m+
FxwghfwuQlpRx2FK/Hm6MQpPnAEY45bwZOV/LduXexdk3yicXmldZnXcTrsfJiIH
FuOqrjohNQEyCoSbxV3rGKb7jsLMRc4/vtMvOq5f5CccnXm0AKzKd+R0shwW9C6G
f12C5NpJoyiwlqGImPZZF3VgIV+9hU/KyKOuh5s8hWb2yhPIH+QW/Pun7DK6eCUC
glb0gCWwOvIhMAALzzmYV5uOkdMppxDTsrTyKCVBNiDRk5XA2iMtq1vSxb3hhP6u
jgMGvBoB/h8OCrsmYj7NnKutNTIpviGcgZdwIH+fT9jB1aY6C/yc56hkQjw2Iofd
pHvg9xY2RbEd0lUUxfqzzeSavOyPE7fIsUyLhkb3EwbsKVLRH9cxtpDscdcykPHZ
2HMY6DLLr+Be3LPhaNj3jdEsFzoRuDP5DCYyKg0Hk25/Ljqgiy3CE0BWA40Dsy4b
cQbsHmx7mnE74ZkNorS8MOoiLBG2PMEQQQdhpfB1m0aZWKNL5PBI99ofJoN8PGDM
IwMrqx6p5YBstLpVk2pJ
=lN0r
-----END PGP SIGNATURE-----

--7trrzIZ+323l9a6P--
