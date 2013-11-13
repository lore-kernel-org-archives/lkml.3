Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab3KMOpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:45:05 -0500
Received: from top.free-electrons.com ([176.31.233.9]:48586 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755562Ab3KMOpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:45:03 -0500
Date: Wed, 13 Nov 2013 15:40:10 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Luca Coelho <luca@coelho.fi>
Cc: balbi@ti.com, mturquette@linaro.org, james.hogan@imgtec.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: add flags to distinguish xtal clocks
Message-ID: <20131113144010.GB3538@lukather>
References: <1382528150.21526.25.camel@porter.coelho.fi>
 <1383933648-28595-1-git-send-email-balbi@ti.com>
 <20131110113716.GN26440@lukather>
 <20131111194247.GB19212@saruman.home>
 <1384199456.12583.27.camel@porter.coelho.fi>
 <20131111205910.GA26440@lukather>
 <1384243549.12583.36.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <1384243549.12583.36.camel@porter.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2013 at 10:05:49AM +0200, Luca Coelho wrote:
> > What I'm not really convinced about is *how* you carry that metadata
> > in the DT, that's all, nothing more.
>=20
> Okay, I get you.  My point is that being a crystal or not *is* a
> characteristic of the clock, so I think it could be part of the flags
> that describe it.

Yeah, but then, a crystal has a slightly different behaviour and
property than a oscillator, therefore the two aren't fully
"compatible" with each other.

> In any case, it's not really my call.  This is about the clock and it's
> not even my home turf (wireless). ;)
>=20
> Thanks for your comments.  And I'm sorry if the tone of my previous
> email sounded harsh, it was not supposed to. :)

That's fine, don't worry :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSg49KAAoJEBx+YmzsjxAgU84P/1O/d3IWpeJCVsC++OVhgene
Jn6x2Wa6Vn1kP67Ppe49gxacIEr2frrGJMUti2F3/mHhCCZdFqxGMbEGUMZCwj/8
zQdlkz8/VwJQEjdLf3Kcl4p0ElYTINPsun0fHc0IJEVBRk3sRNBw2o6J6g4fbuWo
UIkdnpNTHgV1Hru7uDzfWuOlsB1uh4cTCqXr8KBkXIdm54EQ0sD80T5SR4kv5A5h
SSRZV5G8GkTjldx75etkLUQy/xmzPnBl1ftAq/2bSm/KME25vde8GSP5YUmfIfYF
W4Cf1Z9aFFcUZwHlAXl6yTfMNZcq/XjdNegHgTrKOcs+B0GpMYeieIiZfti2aQ/P
+lKJhXxOYsutVveMJaAUpoQw+GoTBAoWUXVNFc6SLZ9fmVjTwqGUpJZXtkvZVTKv
GhudIlFR/5sYYCLRcj3FGAx4JX2VEm9614DYALW0usL/8a6GMsThKWIKaF0QI93t
Uzafw3rZqeJoDBjaDDNkActGz3iSgzEHX4ilm9Lphx59oO+XL/5ZwFpiKOYUVThx
80kJPAkiQ4Qy41D4bBWRyaAkaMKkV17yr6f6HGi22DvD9a3naaMvrVTj6Il4rRX3
dboZEz+zyWKgY9f2Fe0aGL/QOwTwdJbvVZJgWSPrZ5/h5Xgb6K2D1si90OdMvva6
AhY4hUYgGMMA70G1xWD0
=o6It
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
