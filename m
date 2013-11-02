Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3KBUn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 16:43:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab3KBUn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 16:43:27 -0400
Date: Sun, 3 Nov 2013 07:43:07 +1100
From: NeilBrown <neilb@suse.de>
To: NeilBrown <neilb@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH] extcon-gpio: add devicetree support.
Message-ID: <20131103074307.6896ed6a@notabene.brown>
In-Reply-To: <20131102103323.17e208cf@notabene.brown>
References: <20131101205005.659ba606@notabene.brown>
	<20131101171643.GA2643@kartoffel>
	<20131102103323.17e208cf@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BLsscremj/DHyAGgyPsHNjI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BLsscremj/DHyAGgyPsHNjI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 2 Nov 2013 10:33:23 +1100 NeilBrown <neilb@suse.de> wrote:

> On Fri, 1 Nov 2013 10:16:44 -0700 Mark Rutland <mark.rutland@arm.com> wro=
te:
>=20
> > Hi Neil,
> >=20
> > While I'm not fundamentally opposed to this binding, I have some issues=
 with
> > its current form and would not want to see this version hit mainline.
> >=20
>=20
> Thanks for the review.
>=20
> > On Fri, Nov 01, 2013 at 09:50:05AM +0000, NeilBrown wrote:
> > >=20
> > > As this device is not vendor specific, I haven't included any "vendor=
,"
> > > prefixes.  For my model I used "regulator-gpio" which takes a similar
> > > approach.
> > >=20
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt=
 b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> > > new file mode 100644
> > > index 000000000000..2346b61cc620
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> > > @@ -0,0 +1,26 @@
> > > +* EXTCON detector using GPIO
> >=20
> > EXTCON is _extremely_ Linux-specific. The binding document needs a desc=
ription
> > of the class of device it's inteded to describe that does not just refe=
r to
> > Linux internals.
> >=20
> > I would prefer if we could have a better name for this that was not tie=
d to the
> > Linux driver name. Perhaps "gpio-presence-detector"?
>=20
> Maybe "cable-presence-detector" as in this case the GPIO is just an
> implementation detail.  Which isn't much different from "external-connect=
or"
> which is where "extcon" comes from...
>=20
> I propose "external-connector" if you don't like "extcon".

Uhm.. I just realised that what I said here doesn't make any sense - sorry.
I was thinking that you were suggesting "gpio-presence-detector" as a
replacement for "extcon", but of course you weren't.  It is a possible
replacement for "extcon-gpio", which makes lots of sense.

The "Extcon" driver works in two modes.  One in which is can detect which of
several possible cables is inserted, and one in which is simply detects if
any cable is inserted at all.

extcon-gpio only supports the second.  And for the second, I'm beginning to
think that "presence-detector" is quite a good name.

So yes: unless some serious objection arises, gpio-presence-detector is what
I'll use in my next patch.

Thanks,
NeilBrown

--Sig_/BLsscremj/DHyAGgyPsHNjI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnVj2znsnt1WYoG5AQJufQ/+JcnCckYzbXc5FJ7IYwweER+d4aoMRNFl
+s2JJTT0c1rS0q2P8NNiT67pxEKPHL1r5hTDXD7BD45cG+R9gjBOG8XKyFqjFkaI
QR34uNSW4c74qFelzCvjMpQiJ7s4dkRPKe3a44gBHZgz1U6vE2ARXfD8Ab7CM+KP
5hzo0CXRN0Kzo2vLrO5iaEXGyXuQ3mNfGDZcNDFiFfqGLf7CeYAbNhqwcr4fahRa
ObYffJfPrULEWDaFTiaOhkKP3VrrR2F+8Q8k9vb3fsptvyWZ3IV4dRwtwH8CoLCf
eVEHeQn8XtMk+lh/qB+yWItp/WiXpuosbkEqiVQu2HwMebhFFRi7ZcSUVCfou833
9qL1dxq+JeEAYPlm6TClbOanxYbCa291UnbACw03HUV9oqFOrqvtnGy3kG3V8n8l
zeSkhiok+2DOiKWE0iXCAGDWgOKbpTakSDTfIeHX9Wo1+1oUDh8D9BuXK+BeG9jX
ziY6N2oVg/zygmA/F2uZxMFVcSQYBlhCnP4LVJY5KLL/XMZM6BIzduo3FfE6idVq
98DetT68ZrU/kdkq+hVyQ8pfC/nQH2OIPH3asXVyScyXN7XHuFSamGRERcg+5olo
i0vfxZ0TKXVBBeG7cmSqmn6Mpo4mfDWYJfCsugyMv/x6zH/K0QDiQQCEgH5i6xmk
FGASB5qu3Vk=
=9vgD
-----END PGP SIGNATURE-----

--Sig_/BLsscremj/DHyAGgyPsHNjI--
