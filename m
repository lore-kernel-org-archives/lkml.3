Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaIJP77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:59:59 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:64793 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaIJP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:59:57 -0400
Date: Wed, 10 Sep 2014 17:59:41 +0200
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH V4] pwm: lpc32xx - Add a driver for the motor PWM
Message-ID: <20140910175941.5c44837f@avionic-0020>
In-Reply-To: <12709842.iga6ki5KTS@wuerfel>
References: <1410363822-22151-1-git-send-email-alban.bedel@avionic-design.de>
	<12709842.iga6ki5KTS@wuerfel>
Organization: Avionic Design
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/aJF=_5+JtGBXXM7sPp4EzlU"; protocol="application/pgp-signature"
X-Provags-ID: V02:K0:wfCRN/jwbkTIwVDMhLTHvM7HtFK3+lpV0NagrHH3dIe
 uxCBVUvFSp6YDivLv0VS86NHAz700xeL1wG4voY+tEJsq0a8fN
 lbV7weW7kuBeb+i1N/HpRq5FkEdoZ+BLgxioFdhUHujoypjzP6
 GgiY3ZHRIFpkpiPzpxHtGsNow6fcWSYmMyTHG7HXzCzhoRuQYZ
 g1j0Yn1MeW5/1Tr/poxbu0ltBmoW9FozlOYVa5E82U6dgXrxb7
 LcKaXpmmFuFXhyN0k5hy+IvknOi9irkckXx5Hxd+tOwSw1IAhv
 L1qTFcRF1dvrARW/fvsUSkos739cLA3WUu1sAp6ldfVH8JCfU7
 dKkIRfP24JXIhj9Pss7giM7wEA6dSwouxv8kEb7E+hFehE8Wv+
 NnfA+hJ7JkTDQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/aJF=_5+JtGBXXM7sPp4EzlU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Sep 2014 17:51:36 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 10 September 2014 17:43:42 Alban Bedel wrote:
> > +- #pwm-cells: should be 3. See pwm.txt in this directory for a descrip=
tion of
> > +  the cells format. The only third cell flag supported by this binding=
 is
> > +  PWM_POLARITY_INVERTED.
>=20
> If you don't have multiple pwm outputs or programmable period, I would sa=
y it
> should use #pwm-cells=3D<1> and only pass the polarity.

There is 3 channel, so 3 PWM from the API POV, and the period is
independently programmable for each one.

Alban

--Sig_/aJF=_5+JtGBXXM7sPp4EzlU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEHVtAAoJEHSUmkuduC28D60QAJ1eKXrO7mgIgY3DdLIlwnF+
bNHWL3xLskfZFupQStfENDsbVRJl4xExXV1+Vt+TSEK2MwfpLrqZc3xlZdtCef+L
8z32nxviKn7DD1uac0oUzoNfedTDfqIaYi5q0Ty3NcdqxI/oX0QtjZjFxdqIPmhX
siGckYC1+GJGF5R6PsF3tk7zSd+cGxJT2XPiv+s0gqrKSk/seQnje1Ub8r2arnK/
Zq+NZ6kuQMt8xjy7Orl3EdTmR1IySl0TJfSk77wgvLHVbqXXP0AElr6WqBYSyR8z
Qi+5ojz2tIE8eOWYNYQd6tC4IijxdM9K+2b5sd8OhtCtFMzrkdYIg8JVhSsiVocy
1RuPxdEL5QHXp9FJjsMCh8nmNduE4nwajY89BlvyGj9lwd4Dy/qi436Nek+f++fL
FFHCuC5V059regqnJoh+ywHeU/qnDVo3KtmvmqikzZSXzPSRAaRdd6IuruRpUPtg
OiJNJimIX2E9SIavQKOVNphzfk8IhyHIutuP/jdg/8Dv0+IB9pljYb2KQ3kVrIxi
TZjYU5Ebl8bapJ08nwKeLo2eDXIA4TCZXg5+Ap4kFLF6DK5N0MA7fSR28diSViCT
OQprOHis0SU+NeL6Re+rRyrzaw8SE2RsgW7Q1qVoi6VtfzAbiJdj7wJAXXyTEMoc
n01TP8sDuKNcSZVPpk/V
=Nw3k
-----END PGP SIGNATURE-----

--Sig_/aJF=_5+JtGBXXM7sPp4EzlU--
