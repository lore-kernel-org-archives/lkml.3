Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3KCVJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 16:09:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3KCVJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 16:09:39 -0500
Date: Mon, 4 Nov 2013 08:09:23 +1100
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Strange location and name for platform  devices when
 device-tree is used.
Message-ID: <20131104080923.1ea15ebc@notabene.brown>
In-Reply-To: <20131102155824.GG23938@kroah.com>
References: <20131101145925.66e22f73@notabene.brown>
	<1383279744.28909.26.camel@pasglop>
	<1383280054.28909.30.camel@pasglop>
	<20131101160329.37f3707b@notabene.brown>
	<1383282516.28909.36.camel@pasglop>
	<20131101204749.GA19662@kroah.com>
	<1383347399.28909.46.camel@pasglop>
	<20131102155824.GG23938@kroah.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bu7TFMWwKBuv+tdscbup8yg"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bu7TFMWwKBuv+tdscbup8yg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 2 Nov 2013 08:58:24 -0700 Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:


> So go blame them for this, not me, remember, I'm the one who _hates_
> platform devices and wish they had never been created...

Have you ever written up why you hate them?  I did a bit of googling and
couldn't find anything obvious.

Is it the whole concept, or the particular details that you don't like?

(I find the concept seems to make perfect sense, though there are a lot of
details that I don't know).

Thanks,
NeilBrown

--Sig_/bu7TFMWwKBuv+tdscbup8yg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUna7gznsnt1WYoG5AQLochAAsLXEbdfWDIwUy2BSdXxmvD1/FujnHjYq
TDuJVeliTQs4GFbezPNxyrAgD1pByQFfsvz1cbwg9Et5Ju80DzCyi6s2T0Z7Uwg7
txOqWSRJyIq3looyZZZWf8lgovGxFULdl45JMy3sz0Av95YuCCTqeWE+NLPmrBdV
SR1MsaYhkTxRPhQegfeLU8Cs/IRUC4JfNW/nRr7l5kxgMk43mOgWtn/gE0jjcvSf
n8tglq0SB76BAA3v5K+SMCPxAXfr992RtKyMM1DHzkAyD/x9jwKTis7+5oVJssfp
aifAiWJ8qxFXxMV1Liei1H0+Iw2yXyQUzF+xHTepuu7r1lO/2tluM482uyEuqzpb
BeCEOBPIuOHwsICNXVR1T24U++aomn+iolaTEpzIpvS82viHyMms5M0JahdeUxjf
M+c6LfNNbeZuw43/VcmhHy+qmgEvzi4A4B/QH+5+j0Jd5xwYat2JSpEwTA4h+baY
f28Es2MxVcxTtdDlcQwJj9OFm5YD2TX4zN43X6VDgOmPTYJ2PMkIvSL2UCim13D/
7SKclnTSAAq6pSVyOUuxMo8nXDD/BqomaFJuSLjGEsx307YRsT+3MJof3BQOn9AP
oqUwyV8VHglljPWSRytiI3albfOWyc47cYOJ3hmRwXvhMoG/3S3E9dN4VFdOaEnc
DCMR8QcmAQs=
=aZNB
-----END PGP SIGNATURE-----

--Sig_/bu7TFMWwKBuv+tdscbup8yg--
