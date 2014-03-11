Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaCKKBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:01:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55189 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaCKKBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:01:10 -0400
Date: Tue, 11 Mar 2014 10:00:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org, lars@metafoo.de,
        linux-kernel@vger.kernel.org
Message-ID: <20140311100057.GK28112@sirena.org.uk>
References: <1394513002-21946-1-git-send-email-Li.Xiubo@freescale.com>
 <1394513002-21946-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QkLM45cka79H3O92"
Content-Disposition: inline
In-Reply-To: <1394513002-21946-2-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3 resend 1/3] ASoC: codec: Simplify ASoC probe code.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QkLM45cka79H3O92
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 12:43:20PM +0800, Xiubo Li wrote:
> For some CODEC drivers like who act as the MFDs children are ignored
> by this patch.

Applied all, thanks.  I'd generally recommend about putting things like
"resend" in the subject, it can make the prefix awfully long and hide
the actual subject.

--QkLM45cka79H3O92
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHt7WAAoJELSic+t+oim9YGMP+QHHEl4RtOlgTMJYiSw6/Cn2
d1YTpcgYHr+Fp37nHt9qHDvOOW5lK2AxbVVsHWEr1+84zueCFb4/XFlkI3rocWBM
tQj9hm3zzjRed9AYjD2j0aAAB/+qjYpzuu2J/S9auJUg1JUl+I3hx3ZN5dIH8PsZ
fudzgtu0SY+vYI/eJkD7ITgG0MQSjudLn9XDba/R/hXPpWPHVBrGvXA8KgVmBuBO
Ffq9H+SUKQiBZvAREpLFo0pnFIYaUf1ZPyl+aN00zhwEvaOtENeY7wXrSBoX9ljZ
AzypGYcyy57EPSs1f0fj2o3Hy2KskByqR6o7+c+vrcvPmpNV5EX1Vz5L3fPEr6AX
ELVYwgO01n8Ct7IuZKxkL2HRDFHFrQN9W/HS1BOzwFowPlHj5wwiORkbcnPDYG2T
HI6st81pzzBhnJ+AMAD0hDNkAlBzW4ye0mqesJiAM4ASD3ShwsT/UNgtUg5tcp8b
wDokYFhzW42uuPpMWwBz8OL8UpdxhzFsbGTm/3zzR5xRCdsniTL639KqLRsly2UD
sSEMyyBH8LdxXk8t1RrY6O6PT7NlHm6EwZifdMghVQVAYqovbRF1oVYNguKR0B1V
IA0lLgIJrxH2dwHNchDrtu2r+sP3yQ8y3mknFiaqEbiduMy2wXIMoXGgw7QOV6ID
2SmM9sfH7vvFrYT8GHpt
=y1nE
-----END PGP SIGNATURE-----

--QkLM45cka79H3O92--
