Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab3HSOFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:05:52 -0400
Received: from sauhun.de ([89.238.76.85]:39766 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab3HSOFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:05:50 -0400
Date: Mon, 19 Aug 2013 16:05:47 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Hein Tibosch <hein_tibosch@yahoo.es>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-omap: always send stop after nack
Message-ID: <20130819140547.GB4540@katana>
References: <20130716090300.GG8880@arwen.pp.htv.fi>
 <51E5137B.7000302@yahoo.es>
 <20130716094212.GL8880@arwen.pp.htv.fi>
 <51E527F7.4080007@ti.com>
 <20130716112746.GN8880@arwen.pp.htv.fi>
 <51E537A4.40300@ti.com>
 <20130716130058.GD15036@arwen.pp.htv.fi>
 <51E57211.2040001@yahoo.es>
 <20130819121123.GA4540@katana>
 <20130819135702.GC26587@radagast>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <20130819135702.GC26587@radagast>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 08:57:02AM -0500, Felipe Balbi wrote:
> On Mon, Aug 19, 2013 at 02:11:23PM +0200, Wolfram Sang wrote:
> > Hi,
> >=20
> > > > Which means your original patch starts to make a lot more sense. I
> > > > wonder is this is really what we should be doing though - breaking =
out
> > > > of the loop, I mean.
> >=20
> > Yup, that is fine. I applied the old patch with Acks from Hein and
> > Felipe to -next. Thanks!
> >=20
> > > It looks like TI's i2c-davinci will have the same problem as i2c-omap,
> > > and will need the same change.
> >=20
> > Somebody up for this?
>=20
> I would suggest deleting i2c-davinci and making sure it can use
> i2c-omap. It's the same IP anyway. Just an older version which was used
> back in OMAP1 times.

Yay, I'd love such a patch...


--U+BazGySraz5kW0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSEiY6AAoJEBQN5MwUoCm2FIgQAI/+tgjOQW6YGI8cZtcarmyi
DqzdUgjaW0JNywXf+hgcAEkPjpyIcDjONdwWCfu93S0pLjAbZnI/kcHOUt4ealMX
5Y9SctOOBlIh5Y6sKmxSnlBSH8dyJZLKUAjHiF/IYV9hBRYwEZHgVzRygb3EZquD
2B9PtjaCbhz4idenzpG95aNrEV2PyWR0vB6p8IeP8OkaskIVIjyWRXcNUldQwKc9
fRo5AvN6nLpMJ1zgft51C7EU70y8XuYKOCKj7pm2FAtianV0auI5Tmsv1s/nZRgU
MPoIJEheUbwhjrjnkp+CIG3v8Geb1fw996HLwESEeaXLAXzP/WkpXPN6WUKEHqxc
VD3g5b5eidpM8zZ+xULLYf+3JpnQ1rKE3yMUHuY2Kxja9y1oCxumuhrLVebd7S5G
OiUrrvj1Mhf+AH2MfaIq7B/4ITLu/26j6oJWsz2JB2czOf1YcILSE5iH260DOP5Z
4VqYN/DziTEyjnC1H5+dAXiU9T7egcq8uJWJc/r8Xj0gJbpEa9Ja7dQ7qcE+m3+s
KXTXmfxkPHe4mHbJzhcgjszc5hOZ209DAxq2NaFLjgDbkY0/qI/UkLkuWDVtGmog
t/ATURwT//OzA14DlQPrdK6Bz8Aahbr3X8ukEeFGEyy5e87tSZkpmTFUmxvMd5UN
0J44Oiad6ysTrg6tK6Jv
=BI5q
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
