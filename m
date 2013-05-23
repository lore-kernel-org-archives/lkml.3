Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab3EWTib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 15:38:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758400Ab3EWTi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 15:38:29 -0400
Date: Thu, 23 May 2013 21:35:45 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [RESEND PATCH] pwm: pwm-atmel-tcb: pinctrl support
Message-ID: <20130523193545.GF17462@avionic-0098.adnet.avionic-design.de>
References: <1369327132-31935-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9ADF8FXzFeE7X4jE"
Content-Disposition: inline
In-Reply-To: <1369327132-31935-1-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:vRDXb/4RgdirCo8j/ahFGdzByn+F8tAUgBQgo5eLb27
 Imn7rB3UcPDN5tOY6AJvJ26wcwGrHno1FcrJxTXjanzZQ14V0m
 pYJhU892GnxcdF/PESYWZKT41BMFttASLqzep42ziwzyYRcfqv
 qyGpA6tP2AC4arq81d226s6oaJN+33gfF5i9JNB/sJD4boBJf/
 HeEC7vCnoxTw/MTURHLp8Xsed3Fq2PFBFLS4UkdgV1sEyy2SP7
 K8ZiGU4HsLUOkUWvGXZYQ+AsYHFMz/3Y24qejYgCIn27WcX5Ab
 J6BU3PcD/gqRYegoUYsi/IDSLThmbbCSDDDFuKbNNDuSpnAyNC
 PvgWyWEZLSbVEGiFytte6ufa+q5BuwJ9xTy6+6UAuSDc4isFNY
 phvU0ErQf/erRmVmGs0lRmQ9JJ8bxAAc4np4zsIANZIa5+Jrw0
 X+qsk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9ADF8FXzFeE7X4jE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2013 at 06:38:52PM +0200, Boris BREZILLON wrote:
> Hello,
>=20
> I sent a patch 1 month ago to add pinctrl support to pwm-atmel-tcb
> driver and didn't get any review.
>=20
> Could you take a look?
>=20
> This patch adds pins request for the pwm device exposed by the TC
> block using the pinctrl subsystem.

I was actually looking at this a few days back and thought I remembered
this being handled in the core now. There was some discussion about this
back in January (?) as far as I remember. I just verified that indeed
there is code in the driver core code to do this. See commit:

	ab78029ecc347debbd737f06688d788bd9d60c1d  drivers/pinctrl: grab default ha=
ndles from device core

Are you sure this is really necessary in the driver?

Thierry

--9ADF8FXzFeE7X4jE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRnm+RAAoJEN0jrNd/PrOhIZoP/1ycp7ep0ZwjCRhmDl6w2zUi
Fh4tEYDrmSyrC5DrBSiNcgmUBVbt86HG4wNhO5Z9IIJRbXh65ZPzshD/Me5aSten
4LeJ19db8NP/dQVWH5y/JhAivTM4nNzdhMOLrPL9ng9jM8rlTxBRdz4i/NeXX543
NosFa1cHEXOh3tO7PuTjUChJB0Pv0iwlS3k1aER+l2B17Vh4TCMgZ663Czybt/80
hEMPZOP8mSd3d9oKbAPO62qiKtl7KnlxVFQ4+MzQTPytDKESJkyfMvoDsCFkbQA3
D6SlHxlXM1fjsozL5mEjYkLSfaf+H6W8oEdAOH2BXATI+s4D184WLGyUKHfZ+uXF
2f1ANdbonDm+RuVrT8PV0qbUoHtRFYEMLaRyZrfUjCLbw3GTHBwwueUg3QwFnSzB
B1HlXAEwR82wfhX/J/cUUk2gX8UosozXAniQ2tvcgTGYS3X2koVzPaHZ+BGXX2Gr
owUPaMrIPX9ccfVL57nQbMsqYFnd1IOC7azpDCxwUN3N2rKDw5t2Cr+jLxOwvXSd
RerDgENEe84KQFn3jqg42bPiVqXXNvf4h4GD4fgFmkoHqepzzA46WHeNMpHH2fhO
7sbNHQK+F24VzWzO/fOBO9w0iLUoHhB2ESGYcd0BC1ctVVh4Du1X8Nmfzc4Nf64n
f7uM3z5XXRefZgNCllrx
=VKgo
-----END PGP SIGNATURE-----

--9ADF8FXzFeE7X4jE--
