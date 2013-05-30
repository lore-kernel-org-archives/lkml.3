Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab3E3TIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:08:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44229 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3E3THt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:07:49 -0400
Date: Thu, 30 May 2013 22:06:21 +0300
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
Message-ID: <20130530190621.GB6277@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-21-git-send-email-lee.jones@linaro.org>
 <20130529175741.GG21290@arwen.pp.htv.fi>
 <CACRpkda3d9_XvqRmy0nbWyri2xC3Qst2U2Sv=UDxV4w-UxK_JQ@mail.gmail.com>
 <20130530081211.GA1915@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <20130530081211.GA1915@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI

On Thu, May 30, 2013 at 09:12:11AM +0100, Lee Jones wrote:
> On Thu, 30 May 2013, Linus Walleij wrote:
>=20
> > On Wed, May 29, 2013 at 7:57 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > On Wed, May 15, 2013 at 10:51:43AM +0100, Lee Jones wrote:
> > >> For all ux500 based platforms the maximum number of end-points are u=
sed.
> > >> Move this knowledge into the driver so we can relinquish the burden =
=66rom
> > >> platform data. This also removes quite a bit of complexity from the =
driver
> > >> and will aid us when we come to enable the driver for Device Tree.
> > >>
> > >> Cc: Felipe Balbi <balbi@ti.com>
> > >> Cc: linux-usb@vger.kernel.org
> > >> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > >> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > >
> > > for drivers/usb/musb
> > >
> > > Acked-by: Felipe Balbi <balbi@ti.com>
> >=20
> > Is that only for this patch 20/39 or also 21, 22 & 23?
> >=20
> > Poke us if we should re-send them...
>=20
> I read this as all patches in the series "for drivers/usb/musb".

right :-) Should've sent on patch 0/39, my bad.

cheers

--=20
balbi

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRp6MtAAoJEIaOsuA1yqREVk4P/R6VHmRCCXCriVE54Hmy0GWa
8f84Twe/nMu8IOTGmOls1Uk1R7BM8Hj7DKpAoqFr7gsSOdzxXpNNl466wXhawa1i
MlqcP3pd64HEuRmj1G/tL1CLqwACVBiW3k79TGOx9j+CweOzuajY6aLd9NUjYxSl
qTMPjcvqo9xyB9V+pIFIFjnsHQWuou2NWPqZwsOk2D7qlX70DJs6tUnr3VS7W8ox
7MEeah2UTqzNhFo6DmxGvOv+9DwGE1CMa2GDgWHokv0KUYN72kZKCYd/2Fsod83C
97ntU6DjqKJMmaiW/ybIiIEiw8BHv9qnokqA8iCQPH2YuBYB2nIPT5laHYeHk2ui
NaxvKkjFaKRx34m7t8bTYO+5Sggd4gfswfHQ+6Ui9IX2AK8UR8oIacuwrCcMbRq7
wY29JqfN7xFjNbH9Px9KES7TCvuDj546mhwUg0EaZ516svVHTzQYcGq++veQVaos
kJUe3KmekPHvJYna5shLmffwb8095JlqGgelUsUHUPEFR6Mh1RYsat4w6g5RrpXv
m6Cqbzeh1ut1D+Jb7sjOjBSfmm3rSXQ9au6UNFQr+OsFiaxa3Vo5KjHMzbQlUZNf
RfBAYE5AwvKrhJmyA4iyFeu14yB0Ymq9i8VVCLGOcrwXBEQk6agF1Kgt/4QtqMjX
hETBNhbKCU5Musc2V87z
=zy/I
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
