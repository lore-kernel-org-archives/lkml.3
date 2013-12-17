Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3LQNxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:53:10 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59369 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3LQNxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:53:08 -0500
Date: Tue, 17 Dec 2013 13:53:05 +0000
From: Mark Brown <broonie@kernel.org>
To: "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131217135305.GG3185@sirena.org.uk>
References: <1387228827-933-1-git-send-email-b20788@freescale.com>
 <20131216185753.GN3185@sirena.org.uk>
 <c9e35710598c4a66823e67fd4f81c0d7@BY2PR03MB315.namprd03.prod.outlook.com>
 <20131217122923.GT3185@sirena.org.uk>
 <A9C48E12-97A7-4A66-98EB-BA7BC23F27B3@freescale.com>
 <20131217130007.GZ3185@sirena.org.uk>
 <242D3451-6B96-4A0E-88E0-44C4DCCD96FA@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uso+0U0mc6DHead5"
Content-Disposition: inline
In-Reply-To: <242D3451-6B96-4A0E-88E0-44C4DCCD96FA@freescale.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: anatop: add is_enabled interface
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uso+0U0mc6DHead5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 01:10:12PM +0000, Anson.Huang@freescale.com wrote:

> > In any case I'd be much happier with this patch if it implemented the
> > enable and disable operations as well.

> understand now. then maybe I should remove the PU check in cpufreq,
> although setting PU LDO if it is off before would bring unnessary
> power leak. I will add all these changes together with the dynamic PU
> LDO management feature, thanks for your time!

If you've implemented the enable support correctly then setting the
voltage shouldn't enable the regulator.

--uso+0U0mc6DHead5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBAgAGBQJSsFc+AAoJELSic+t+oim96I8P9iIzezhfagGKQgfGeiHQZMY1
BGw5D2RRU8RQJ8ziuJZzXcOfr3rznugxFFil7VK/Wg6q+ePzm6LcM2DAK7o17Qd8
gH1XGqAN9f7OJr7OTyhz6aH214yRwnzqitylA6iTu1ZZ7bHccFCs13hiI4eW88Oo
dsZwMJWjPmSl+YgeX0z8MhGLErk7kvQvW0ffEJIl4Gj9JxxmmiEfyO9WI0QW5V4S
4EW4egQOh0jHj5k7BvGhCwGYZDFV7Qa+prjRwqwYxAkGoJkUhNKtVoJoQYiDK82A
GolFq0W+1valoysalb+rLwbh9QihK+Om21KvEXDAX4epNnQpaKNBPAgxt16BOQRj
3shD0zFIKOenN9HMd9Sn/QV4fOlvLtDpkR0ihzTmnBk2AOX3JJo4nXYC/LEodDxe
SvlwQ43yLRNjhM68SEM+4jBv2no3VPLBq/Qh+Byz7lN3ULlLOBsJgjhQRpCgfmnN
5mGUhINPFU8YRrf87yQO5eb/hvdwjw2Pp95QgigR4yr9JD7AVWRul7EjhqPXNYcN
dDUsJGVMbWaNLu/askV1dStMNgH9pbRRxsnAGjmmLwwDu9dJyOVSs/i0MnPASwrG
Jmg4npvk+S0KPZMvujipsxeLOURGeISrxwVJS3K8JELFz1hSw60qgnhTuoD+D+MZ
MP9dgt86Npae0fSdrcs=
=tOen
-----END PGP SIGNATURE-----

--uso+0U0mc6DHead5--
