Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160Ab3BSUHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:07:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55496 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933823Ab3BSUHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:07:09 -0500
Date: Tue, 19 Feb 2013 20:07:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Axel Lin <axel.lin@ingics.com>, Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: Having slew rate settings for other
 than SM0/1 is not fatal
Message-ID: <20130219200703.GE23508@opensource.wolfsonmicro.com>
References: <1361015443.11226.1.camel@phoenix>
 <5123ACA1.9000408@wwwdotorg.org>
 <20130219182647.GD23508@opensource.wolfsonmicro.com>
 <5123D362.4000702@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WK3l2KTTmXPVedZ6"
Content-Disposition: inline
In-Reply-To: <5123D362.4000702@wwwdotorg.org>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WK3l2KTTmXPVedZ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 19, 2013 at 12:32:50PM -0700, Stephen Warren wrote:
> On 02/19/2013 11:26 AM, Mark Brown wrote:

> > - what he's saying is that the error handling here seems
> > excessive.

> Why shouldn't the driver return an error if it's asked to do something
> that's impossible?

I'm having a hard time caring too much to be honest.  On the one hand it
means that if that feature gets added for some reason new DTs won't work
on older kernels, on the other hand perhaps the hardware doesn't support
doing this at all.

--WK3l2KTTmXPVedZ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI9tgAAoJELSic+t+oim96IsP/3I2xHqQ1lEWA42YSjeeB+/F
Z6wFXIGJTZ+qjcIXmsCteI7SWMi4F3GFEXMyB2bj6PiH8uEkY8/SPU2BFn/RtDY6
+iQMmRamtjeFlwYZQmhtsG1w9D7wjlAx8pGvLL6z51KTluxo2jXbFh+xx91Su0BM
GEuj6Knp2PhPyJgPmqp3pKYR545cbJid2+NXh9jm8EUOneWr7FGnKs522sHip9iH
LjNIlSzTZ5B6iRo78PclC0IpTk7sgguTVdB18qGR8DTpnnz9Jl6AuQEAuW+W+wd4
3gZeIBfdDjFv4vDqMSMGvY92DWQrkyuXWEs8JsVYHIOgH+DakNSpTsTljBXuKduV
jTFVstxKPQZefc60i6KKPgmybJkwqmlKLmMty6NyKS8fITdnFJa3Rswcpvd9iDZY
Ri9eaIUh2WPWiNRowR8jIdhi8LjhkSf9ONiMJX4yvwcxKMLDHsHxusJiZJeYpxJi
igS4Cpm6cCrVfxtNiRc9EdmuuXh/y9bQ+UqRqdRhUqot7OAuITeKo8LIxUcAuCLP
IVkC370g2mLj2sb59VQIDBphuvUnl6MW8T/6kBhWaPXdT07g11C61yT0SCYuozcT
kKK/fnNMvPbMnf64qYnBNG1kI40y3fO+Mlhoouvw4rKYdidH5x3GNaq6jR3cRF6G
cXabVSnbArf6ecBqoKWt
=coux
-----END PGP SIGNATURE-----

--WK3l2KTTmXPVedZ6--
