Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaI3MiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:38:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54533 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaI3MiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:38:16 -0400
Date: Tue, 30 Sep 2014 13:38:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, lars@metafoo.de
Message-ID: <20140930123801.GA4273@sirena.org.uk>
References: <1412019553-19342-1-git-send-email-stefan.kristiansson@saunalahti.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <1412019553-19342-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] ASoC: ssm2602: do not hardcode type to SSM2602
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 29, 2014 at 10:39:13PM +0300, Stefan Kristiansson wrote:
> The correct type (SSM2602/SSM2603/SSM2604) is passed down
> from the ssm2602_spi_probe()/ssm2602_spi_probe() functions,
> so use that instead of hardcoding it to SSM2602 in
> ssm2602_probe().

Applied all, thanks.

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUKqQoAAoJECTWi3JdVIfQYQ0H/R4K3Y6//gGd/7IqLveFV275
kdsfGJuuXYlZLM9ca4qzVImSNWiiJY9rwIXy7vu/4XzOJcNRsCtSXp9Qe5vnuvZe
nPFgdmq28f6S5Rhj8pJGmNwXfD8ockAMEvhdT5D9OJBkcrwf9EowTExjQ4T38vlr
p/Laju9hLWoyW/6WjyvFNl+h+yk6aTNtlW2mAYlKkzRzHCJeRCTKLdR78NWYXmrK
GR1tnt/3MGB1CS+qw49DSsywcci1MTc8SOTShLMvFqH5X3BzaCq2U467cZpmFYVw
O6fS/bqGTS2ELcj/VjPUyOfbBo0Jo2ksDYuCKUbsPjUjI1SFER+7XXXX90ALgeQ=
=rlin
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
