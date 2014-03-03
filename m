Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaCCTH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:07:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44362 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaCCTHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:07:24 -0500
Date: Mon, 3 Mar 2014 13:05:41 -0600
From: Felipe Balbi <balbi@ti.com>
To: Chris Ball <chris@printf.net>
CC: <balbi@ti.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        <tgih.jun@samsung.com>, <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: host: dw: fix possible build error
Message-ID: <20140303190541.GA27953@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393340264-22687-1-git-send-email-balbi@ti.com>
 <530D134F.5090403@samsung.com>
 <20140303180614.GA31301@saruman.home>
 <86vbvvqf6m.fsf@void.printf.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <86vbvvqf6m.fsf@void.printf.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2014 at 07:01:53PM +0000, Chris Ball wrote:
> Hi,
>=20
> On Mon, Mar 03 2014, Felipe Balbi wrote:
> >> When you send the patch related with dw_mmc controller, could you use
> >> the prefix "mmc: dw_mmc:"?  "mmc: dw_mmc: fix possible build error"
> >
> > sure, no problem. Do I *really* need to resend though ? It's already
> > -rc5 and I still don't see this patch merged.
>=20
> No need to resend, I can fix this up -- pushed to mmc-next, thanks.

Thanks Chris.

--=20
balbi

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTFNKFAAoJEIaOsuA1yqRE8qwP/217LyoidzHj0zWRdzQA4+T8
gnK2BWNeM6X8RCaZ07CXr3sA4Vm/m+aHMdKjPS9opAbG65npgLTS29r2tgbNvSsp
9Zn2mUnZHsS46P7jafJdeKne9V0dwQOcSK9RJxMvHKQa1cIVkMzpLLmZbEqnVeCu
bjRdDbJQ35FArg8ZWvrU7n4/MBbHX4zuIBuEqrQNiuIx15YCBmvBIhTC/yY8qvcg
QVzR5YIXfBcAokvwchlNWSW6WqNRAN/bQO0YKjyQL6Cwo0nGjf3Dh1r0EGhuEcOe
D+ToVcls8wvB44CGnTjARRglAvYuvlUlX9YeXdfWbn/r7bmjSpsc5Cl+flSIZx/y
SR4mqFIJ9Ku+Kle5eCO2UTeeXRjvz31MKF+GWw3iL9wTSM0NLMZZVdHVpm8DUMMO
EXr2w0naFm+5vkDE2wpKcWUpj6jE8D+syospzJQOz/Xou7p2IcVW1E6GgGgM6ISr
GGFN9FFKuCUJ1zMNGJNWoZMOK6z+udIemskLcyp7IL8IRhFzvyRfkUPPxUHTppJn
mbknJB/nkZOfU67Kii1GXtGGsMUifpjIXTcmmwdyve+7VtrsyY0SVQvW0b020Dfj
5bNOCrUfc5XXfqqQkHHyodWOXCY+zic9N1GrsoiFzRJJE0K0Z97YJRrM4xdygQY0
0jydMRpyrZNaU2vt9O+9
=Lcar
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
