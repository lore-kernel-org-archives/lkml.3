Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3GPJXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:23:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40938 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3GPJXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:23:46 -0400
Date: Tue, 16 Jul 2013 10:23:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, sbkim73@samsung.com, lgirdwood@gmail.com,
        yadi.brar01@gmail.com
Message-ID: <20130716092326.GA22506@sirena.org.uk>
References: <1373184889-16929-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <1373184889-16929-1-git-send-email-yadi.brar@samsung.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: s2mps11: Add linux/of.h header
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 07, 2013 at 01:44:49PM +0530, Yadwinder Singh Brar wrote:
> This patch adds linux/of.h required to fix an error and warning reported by
> kbuild test robot for some x86 config file.

I already fixed this up (I just amended the original commit) but thanks.

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5RELAAoJELSic+t+oim9dmsQAJuBOEbDaBU4B9MlU0ovJiw6
T7Db5Uctns1v6W2m5F+41jqUumYvaVwmfO36WH5aPdQQJ5cjvWiRYafhDwDXPOjk
L7yPLDpZugXRthKv8CTmi/UuFg/910oeQAfAguzwXPpdXYdzVlPLI8WodLRVV7kz
yjm01gPc3kHZKOeiJWCNRuonxRdPFJ+mbIXDjGdWv4wEhKImTiAD1IAV5zsj0WC3
p/0NnpKspE4wk2FJt7fcweAGGUJ37l0yWyKWFUfT2b39JG14RHeULB19dnU7xxNQ
O06y7taeEoO4mxkeUZVuhY54vGHyfWhZEu9nA1xFLnYGORp/yaKBJisk0/56ubKK
AcApg0DDT3049/mf5uXVi1r5CiK5wZIBTQ8jpfQggPqXB/XlYoIradBvMS4uyR1H
OH/fOSE9B/4Nj1z9BHDOHt7Vtqwl4xG6ymEl1l/VP66efy0uFDg/CMAQOgValau6
kFzS3iHuCv1VbwWmNFJgQynU/03zOckoeWZqEgyWwabEfwEUxQE62L7R2g1qzkwg
VXSjeb0WnLbuUa3BGTzK5bdMEVof3iQaqi+TfJxYIgdFZHH1/+QVv/DBjTTO1J4O
l5/E67wV6KFKNCIu9MpX+CDWM6WfdGb09O3d4BRMBhfYlH/uvRtvXvl5A3p33dN/
PmGNXdBtGy6hzjBABc1+
=p/rQ
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
