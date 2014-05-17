Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaEQVHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 17:07:09 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:61319 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaEQVHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 17:07:06 -0400
Date: Sat, 17 May 2014 23:06:59 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Fix wrong value written to PLLE_AUX
Message-ID: <20140517210657.GB1046@mithrandir>
References: <1400248220-16025-1-git-send-email-ttynkkynen@nvidia.com>
 <20140516143110.GA28338@ulmo>
 <5376373E.1080401@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <5376373E.1080401@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 10:05:18AM -0600, Stephen Warren wrote:
> On 05/16/2014 08:31 AM, Thierry Reding wrote:
> > On Fri, May 16, 2014 at 04:50:20PM +0300, Tuomas Tynkkynen wrote:
> >> The value written to PLLE_AUX was incorrect due to a wrong variable
> >> being used.
> >>
> >> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> >> Tested-by: Mikko Perttunen <mperttunen@nvidia.com>
> >> ---
> >>   This fix is required for the (upcoming) SATA support.
> >>  drivers/clk/tegra/clk-pll.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > Reviewed-by: Thierry Reding <treding@nvidia.com>
> > Tested-by: Thierry Reding <treding@nvidia.com>
> > Acked-by: Thierry Reding <treding@nvidia.com>
> >=20
> > Mike, Peter, it might be good to have this go into 3.16 as a
> > prerequisite for the upcoming SATA driver (which presumably won't be
> > ready until 3.17, but in that case it would be good to have this
> > prerequisite merged already).
>=20
> Probably even Cc: stable since it's a fix for a bug that I assume has
> been in a kernel release or two?

Yeah, I guess that makes sense. The bug isn't visible yet, but back-
porting to stable might save somebody else from chasing this if they
ever decide to backport PCIe, SATA or XUSB.

Thierry

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTd89vAAoJEN0jrNd/PrOhghsP/0cLORjtzZ/FziFv1QJnRHY7
bcaCcu7Z2YSvjyRWR988jRESdj7QAz20tzCXunav8GheXVinHu+ZOCky83onm9HQ
oZ+D5bxhXSXOC6ebFetb/lPlANCem8bYAWaASEGMYY84tuoz0AilaKjUe/DIg8hN
pbEUwTuzgJZKPpCD1lty9ZA5nJPHQXVczulyyiaHWcF7WIDZ5exF8SrAV6edYFpo
2c6Mpl8QGzcLsdPlHlS3GAAV+MrsZVthGJbj+QQgU6K0oc5lAL7QHlNVNcy34k0R
bsfz+w8oL7b0ySBltq8tDiW5RJ6WqnHQ8WkrHAb6eZa9bxmamrQlk24r5QFYddp0
lFYkqbdqxjOk02Zm1V0SAxa6YxZGv4oGAphn8YVVb982ROsNDJO1Ufrs9lP36fiK
7JZT7ib5B2sIJl0yiW3SiXlPsn0NDNdTLi9tY/0SlCddRwOUpOCFbxxAdqhPj2cY
CsZ/04xqrD+kkthnEAmtN6uXgqfi6U8smQpR99gvKxYmoSoV7yXINAGfPg3E02oM
pwmjVdZVpWo32kUD9h/b5MIdiuX2MTfiLCqK96Qy2jJO0g7tQxtaKLx4KX8usMAy
HNZkBy8BHmFa/jDzWf2EyWM3PXUH+uL62IeEfajQO5UPkHYyVlNexJF0m2JADOzW
fms2PTVrc1jjshWHSoOt
=iaRZ
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
