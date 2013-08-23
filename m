Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3HWS3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:29:38 -0400
Received: from ring0.de ([91.143.88.219]:49959 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab3HWS3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:29:37 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: ring0.de]
Date: Fri, 23 Aug 2013 20:29:28 +0200
From: Sebastian Reichel <sre@debian.org>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, Kevin Hilman <khilman@deeprootsystems.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Subject: Re: [PATCH 1/3] ARM: OMAP2+: hwmod-data: Add SSI information
Message-ID: <20130823182928.GD5753@earth.universe>
Mail-Followup-To: Paul Walmsley <paul@pwsan.com>,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linus.walleij@linaro.org,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>
References: <1376237628-1077-1-git-send-email-sre@debian.org>
 <1376237877-1740-1-git-send-email-sre@debian.org>
 <alpine.DEB.2.02.1308210113040.6426@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gr/z0/N6AeWAPJVB"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308210113040.6426@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gr/z0/N6AeWAPJVB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Wed, Aug 21, 2013 at 01:22:09AM +0000, Paul Walmsley wrote:
> > From: Sebastian Reichel <sre@ring0.de>
> > This patch adds Synchronous Serial Interface (SSI) hwmod support for
> > OMAP34xx SoCs.
>=20
> a few comments:
>=20
> - please add your Signed-off-by: to the patch description, per=20
> Documentation/SubmittingPatches

I assumed this was only important, when I actually want to submit
patches.  This was merely a first RFC. I will do this for the next
round of patches.

> - please drop "omap34xx_ssi_irqs" and "omap34xx_ssi_addrs" - that data=20
> should go into DT now

I'm currently working on converting the driver to use DT.
I will send another patch when I'm done.

> [...]
> FYI, this is stretching my recollection, and is not directly related to=
=20
> this patch, but I seem to recall that there was a problem with auto-idle=
=20
> when SSI was active on the 3430.  Basically, if the SSI was active, but=
=20
> other CORE_L3/CORE_L4 clockdomain devices weren't, I think that DPLL3=20
> would be incorrectly shut down.  You'll probably need to check the Nokia=
=20
> kernel source for details.  I thought we had a hwmod flag for this, but I=
=20
> guess not.  Anyway, in case you notice odd behavior...

OK. Thanks for the hint.

-- Sebastian

--gr/z0/N6AeWAPJVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSF6oIAAoJENju1/PIO/qalSwP/Rgpb0a3+AjdbcthdW3lIwuS
+YTq/pMYY+FUD2qaKe5yDOsq0mGF4Jw3lnMEfq03oLIqBcxRuizvjE5rL3ylEAAn
z22PhDssfYNNQ2GB4zWBkTao/Ay25WLkg2WJ2SCTjA0qHs53TJO17RFAMcHIyQjD
kqXLPE0H5YwVz6wcrlx0KnqISmbrxkGWHNq7kOaFDvrKsGnkqJAEB+Y3rBBrMfmm
SzeThkZvN1aABYwOBc1EAfSu4n/uhuqAyFMSJUvKO8wHv7H0svadscD70nxaPyZS
dK9gDgr59zf4kwE+5FPe95ixirhSxpnd+RuoTJUe89bs2M050cQQf0B/r51Tv7vt
875vKDS5GLBMVsY9Z1+mXj6CnJeXsp1cLxN4zheEtzqgk5hIA+duOZ9MrBZfOs7H
yh8iGbPbOLAJd1ZD/aX+jy7f/hxxi6bHvxCQ0I8aPi5AQhVLjNwpSEKCkPciP/Rh
Bnrxk+7SRi4LW7bHHSoKJ2tFKAeW8LObsbgUVaDCxqqlgUU3eYMj6W3G8C3PYUI5
5eWPTUvJf5mGqOVgRQJmQWICfEVcHauKd1Qr5tf+znylMmv5YodIl2uZCDUzrvYn
cppCnDlFVfr1piDGWjlZSC+W+Yjb9YQGFuqAddF3wu/aiNfQYa1Ttb4exHnzzgxH
f7yWIg188PpWYAjSjyQ2
=sQGa
-----END PGP SIGNATURE-----

--gr/z0/N6AeWAPJVB--
