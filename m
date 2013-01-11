Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3AKTjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 14:39:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48039 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487Ab3AKTjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 14:39:52 -0500
Date: Fri, 11 Jan 2013 19:39:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Olof Johansson <olof@lixom.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, voice.shen@atmel.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 0/2 v2] at91/ssc: fixes on ASoC tree for 3.8
Message-ID: <20130111193948.GA8677@opensource.wolfsonmicro.com>
References: <cover.1357912706.git.nicolas.ferre@atmel.com>
 <CAOesGMhhSkrvP7X=y8qmdMKKXZ694+1+ZXY3y6HK1E85qaN5sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <CAOesGMhhSkrvP7X=y8qmdMKKXZ694+1+ZXY3y6HK1E85qaN5sQ@mail.gmail.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 11, 2013 at 10:52:19AM -0800, Olof Johansson wrote:
> On Fri, Jan 11, 2013 at 6:08 AM, Nicolas Ferre <nicolas.ferre@atmel.com> =
wrote:
>=20
> > This material was designed to enter Mark's fixes queue, but as discusse=
d with
> > Olof, we can imagine merging everything through arm-soc or split the se=
ries (of
> > 2 patches) and let them progress upstream separated (option that I do n=
ot like
> > even if I know that the consequences are not so dramatic).
> > So please, Olof, if you feel confortable with this series, tell us what=
 you
> > prefer and we will make our best to make this material go forward...

> You're setting yourself up for awkward merges. The driver change is
> strongly dependent on the device tree change by failing probe unless
> the device tree update is there, while before this patch, it still
> worked.

This is partly my fault for getting grumpy about adding the bolier plate
code without error checking - overall Linus' change to do the get in the
core seems like the most sane approach here.

> But to be honest, I don't think this is a fix, it's a feature that you
> just didn't include in time for the merge window. I don't really see
> them as appropriate 3.8 material at this point.

Jean-Christophe has been most insistent that pinctrl support is now
manadatory for all AT91 systems using device tree.  Unfortunately
pinctrl support for AT91 only came in during the merge window and it
seems like it's sadly been impossible to do what seemd like the obvious
thing and add the pinctrl bindings to the DT prior to the merge down so
now we've got this mess.  I believe the way the pinctrl conversion was
done renders the audio driver non-functional without this series.

> So, nack on this series. Please make the driver change non-dependent
> on the new dtsi contents, and merge that through the ASoC tree. Then
> the dtsi update can go through arm-soc, and later on you can make it
> mandatory.

Like I say I'm not thrilled about ignoring the return code TBH, nor am I
thrilled with the way this has been handled overall.  That said, the
current series does seem like the best of a bad job - as I understand it
we need something like this in v3.8 to make the driver functional.

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ8GonAAoJELSic+t+oim9sr4P/0pLO11Ejs7DGV2RnQTWaKgp
D+Upa5WItdyTKSkF0N25tkt5c7wvPA2WJZBrvYDGQ9zCFe0t7hbLDfG+Xa473cAo
CjPdvd6XQjDev+GnMfLlShYDDVK6RgskV3nJnnJpC77j24S6HxQdPpf83LMqnbHF
9B+kP0yegH69SbBCdCQfnSmhtWhXblyVW1+lHTHq0KjaJou82gK3OfnPpynnnzVs
hOyUhATBo2jt4QWElrVzSfFW58jLET57YqUe8okVUKwp+yoXF8zuo8tI7JtrtVBg
irjv94q+JE/PWTuGreZNxuiDQ2G7bmLchLYxb9Aej0Gs0n7HCdT9VEZGNfUYIgLJ
pVL0pCakmaub+ge2HFmht7DjtouAyeh1nq+p7uy9duws3xUaG7DrIAeavba3/TKr
b7o1raLfxRIGyQicfuHSXI3jWJ6YoTFIYp1PGoJBG/uaGDlGcF0Tt7YE5t1APG8F
22e6VWE2mQ4AKG2mOqHy0EfiGtoQvrkME9Sqmw2J3aWslfVAJ9kJrY6HLJkKVbQ+
crPOG1HL1SBL32JcQBMVvJvWAXlelyaMDsa/ZS0pGkSkVS5RuEiantSjognzjY9q
wlAaXDgdh6m9Kd8d+C5ipBStr90925QSaF83+6qqGYJKbsxI0yl3P/hrwATHpaB0
WwiQoMHjSYNXXGrjsCK2
=fwOX
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
