Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaI2Tpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:45:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35016 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbaI2Tpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:45:47 -0400
Date: Mon, 29 Sep 2014 14:45:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Daniel Baluta <daniel.baluta@gmail.com>
CC: <balbi@ti.com>, Michael Welling <mwelling@ieee.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] iio: light: add support for TI's opt3001 light
 sensor
Message-ID: <20140929194530.GD1939@saruman>
Reply-To: <balbi@ti.com>
References: <20140919162129.GE26946@saruman.home>
 <20140922140914.GC25620@saruman>
 <20140923140924.GA28592@saruman>
 <20140924143610.GA17997@saruman>
 <20140925221619.GA10644@saruman>
 <20140927041959.GA28445@saruman>
 <20140929140227.GD32403@saruman>
 <20140929183856.GA11871@sysresccd>
 <20140929185325.GA1939@saruman>
 <CAEnQRZDgrwXuVxD8851i+c6eV5MRjsN+CmWxkOpWnbpkTLH1XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mJm6k4Vb/yFcL9ZU"
Content-Disposition: inline
In-Reply-To: <CAEnQRZDgrwXuVxD8851i+c6eV5MRjsN+CmWxkOpWnbpkTLH1XQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mJm6k4Vb/yFcL9ZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2014 at 10:07:32PM +0300, Daniel Baluta wrote:
> On Mon, Sep 29, 2014 at 9:53 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Mon, Sep 29, 2014 at 01:38:56PM -0500, Michael Welling wrote:
> >> On Mon, Sep 29, 2014 at 09:02:27AM -0500, Felipe Balbi wrote:
> >> > Alright, this is already ridiculous. Andrew, if I resend the patch c=
an
> >> > you apply it since maintainer has been ignoring this thread anyway ?
> >> >
> >>
> >> Do you reall think this is the best way to approach this?
> >
> > when maintainer doesn't respond for weeks, yeah! Sure it is.
>=20
> This is ridiculous! Jonathan asked you some questions about the implement=
ation,
> but you ignored the request. Instead you've send 9 ping emails!

I ignored ? I replied straight away asking him to tell me exactly what
he needed and pointing out all the things which he's complaining about
that he asked me to get rid of himself. For example, original driver was
using devm_*, Jonathan asked to remove, I tried arguing and he said he
wanted them out, so I removed, now he's asking me why I didn't use
devm_* to start with.

That's ridiculous, that's what pointless and a total waste of time.

Not to mention that there was a long hiatus from Jonathan for weeks
until he said "yeah, sorry, I had forgotten about this". Because of
Jonathan alone, we lost a merge window. I send the original driver
because v3.17-rc1 was even tagged and now you tell me that it's
ridiculous I'm upset with Jonathan's lazy responses ?

gimme a break

--=20
balbi

--mJm6k4Vb/yFcL9ZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKbbaAAoJEIaOsuA1yqREq7kP/R0enwo/pG8eVMnXGcuXtxBa
JxjEMIC3Cq6/u5J1Wf6SVFVAeIzV56AtAzaVrZYAUNpzIY3PkAeFF3nY5t+rkf30
I+natJVegDDwKoxQRCHE4DSrtNISlR4RYjaFeLm8eNFXyTS+kcb/lUvn2XqtPXbx
yq4TcTEd/zQIUDDY8cziUxMB7ORWh13b2LWhVY7psYT34puNd4i6uUgmKe/HtI8e
BrcZg+XM/ikJOD2/TMsAcsmg0iV3EKCBDdRnrOBcKcSq4O5/cZjW5ns5cJh9aG3/
RXGPsb6qJ6T3WgPZhQn05kXa07qNB5BKFVT8ICkXSjGUzNzpC9MY6ALT6tQUSAuS
0l8IGqKTwP+fNnpqMpekrfzJyHeJYJJ5/BVLmPMLUo9PP6/CJyvcXK1lffXWh165
RnZ7I4dkxEHfOaF5D846JfhSP26TQ1zmIRqI0pOUAM3JA6dK6P7Ugz0SED+0Cq+H
+Ql+kGXeoqDpv2lqgZQU+i0Mb+15rSVkUX7/BOigBn7YwsRvIjsh84XJOEdII1fz
RKYOUQCSCSrAc1hJuIsv22EmrnaKAXy110ni9QJh2zLo33cYKN4eR4faz8p39I0+
3Ws2FFksEscXEu7NgNTraHwheeQBxwxUrI4L59OpKR7BerQiQOOM6vL7B6qUirwl
odq4N3X3TBEWNI3AAIpY
=KITa
-----END PGP SIGNATURE-----

--mJm6k4Vb/yFcL9ZU--
