Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbaJ2Mad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:30:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55192 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbaJ2Mac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:30:32 -0400
Date: Wed, 29 Oct 2014 12:30:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141029123005.GH18557@sirena.org.uk>
References: <1414570560-10320-1-git-send-email-mike.looijmans@topic.nl>
 <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cZT4zKSEMdXcwoCQ"
Content-Disposition: inline
In-Reply-To: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cZT4zKSEMdXcwoCQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 29, 2014 at 09:16:00AM +0100, Mike Looijmans wrote:

> +	if (!status->voltage_set) {
> +		if (of_property_read_u32(dev->dev.of_node,
> +			"ltc3562-default-voltage", &v_default) == 0) {

A couple of problems here:

 - This contains DT code but no DT bindings documentation; the binding
   documentation is mandatory for any new bindings.
 - It's not obvious why a "default voltage" property would be device
   specific - what is this for and why is it being added in an
   individual device driver?

--cZT4zKSEMdXcwoCQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUN3MAAoJECTWi3JdVIfQ3FEH/3AM3hruAGXrbQGn7ZazVM91
FnEuRaMRQxUmffvhYjF6jrmOASBdQ9+zqc1HWcE7jEMIsfuReyOnXVfGByKxXwqv
EUgC7yN+ZA8NPcKKmLbMJ+/xGhC6TH+usbU8CSgigf6kMx1BG0jcDk+vKwJqfTcG
LzNAOA7qZWjqu+pFRJWOKXiqQ3Mg7K1fttbCBs7kRDfosWQRFdM9mODjh0WgSwVG
3gmZGaHC7t6L4bvkWqEsY1fn+laIJtsRPNZigYkEezwyUEDDlpyZoM+hZZmqzPdo
qFcqfqXfxQ/2KCxf/tmQUiXkkYLt2CVBnR+QihmsclVjBzNmgHnRDntpcC7L4SA=
=sdxI
-----END PGP SIGNATURE-----

--cZT4zKSEMdXcwoCQ--
