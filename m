Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3GZJyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:54:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47912 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab3GZJym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:54:42 -0400
Date: Fri, 26 Jul 2013 12:54:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Olof Johansson <olof@lixom.net>
CC: Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: at91_udc: Check gpio lookup results
Message-ID: <20130726095437.GB2970@radagast>
Reply-To: <balbi@ti.com>
References: <1374605750-29565-1-git-send-email-olof@lixom.net>
 <20130725161406.GD31835@radagast>
 <CAOesGMiupSqpqfyuJ_abr4UQj9Ot77aGJZTsCEY63v-XttgPgw@mail.gmail.com>
 <20130725171951.GD25415@radagast>
 <CAOesGMgn0H4pteeWQcBzcccHr+F9Cf=Y+wvKHr2gCMfBBieOWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <CAOesGMgn0H4pteeWQcBzcccHr+F9Cf=Y+wvKHr2gCMfBBieOWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2013 at 01:59:51PM -0700, Olof Johansson wrote:
> On Thu, Jul 25, 2013 at 10:19 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Thu, Jul 25, 2013 at 09:18:39AM -0700, Olof Johansson wrote:
> >> That's what the code does today, and I wasn't trying to second-guess
> >> their decisions on that. Chances are firmware, in some instances, have
> >> left power on so continuing might do no harm.
> >
> > fair enough, then let's just decrease the error message level to debug
> > or info.
>=20
> Fair enough. info seems appropriate (or warn). Want me to respin, or
> can you edit when you apply?

please respin

--=20
balbi

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8kddAAoJEIaOsuA1yqREYMcQAKixbkKy2fpbpcfjdS7ZrMXj
7RkOd7ZIB4exBGFO8g7kUxe83OdM14ARDBMVnEAnVo8DMqvDEwcj9m1145UnsDYm
V9NEPW3EieT8llQ6OA1JU5V15OxyqH/4vp0sdKO1i5Kzc2uADOgY80QFgCkfa+t4
APhn6eRm0K/hpshVq9yAk3qkpEkI5ldFeGbzrXJNzJHv/y/1bJyCrphkAPUZ9TKJ
mnRV97Pt5qvD2BLj3RXIxzeiRLQC2JyOCkVTuR0SYCLtOyv1Nxh3FstRZ4nIakqT
zj8sIAPQKDZbT1p5KblHYQmnqkHAPD3eukklwWbpmYoltCQElNW2TRFaKyT+N9FT
516Gl8EiZOZsT4BFWGtWc+FmnWpFzrQXLMbq4idR2JaFIDufj7VXB7YKqj6HudnA
O32GyXw0IUpd45kWFYb15A5/5WiTiKg9GdI6IjxCQcZccqYK/VH61vaoaEyTkJB4
hVdZU/9RskDwOSYSwTZA21ZeOIlcT7CGbtiAmrqYPgNnchQi5leUubnpCng/4m43
yP6v/vWQtj7GCJIAkh5LRqxR1vtWhSAOXi6Umu9jyOxAnAmSwP01lz4zISZcXL+f
AXUUHWb4DJiiqicYpk6jhjclod0D9u6GTZyxARPHm/RYRVuZrWECDnjRCFgKyCq8
dU1apuHHJea+gWBqLnJi
=QKai
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
