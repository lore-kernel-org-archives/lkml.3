Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3IUWtJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 18:49:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51657 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751823Ab3IUWtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 18:49:07 -0400
Date: Sat, 21 Sep 2013 17:49:00 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: cinifr <cinifr@gmail.com>
Cc: coosty@163.com, Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 1/3] Add smp support for Allwinner A20(sunxi 7i).
Message-ID: <20130921224900.GF2779@lukather>
References: <1379768716-11672-1-git-send-email-cinifr@gmail.com>
 <1379768716-11672-2-git-send-email-cinifr@gmail.com>
 <20130921140059.GA2779@lukather>
 <CAK3cCByL3nD5pMdDwAkxOE8pP0HQEWthD1HUPJ70VeprNpLzBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0hHDr/TIsw4o3iPK"
Content-Disposition: inline
In-Reply-To: <CAK3cCByL3nD5pMdDwAkxOE8pP0HQEWthD1HUPJ70VeprNpLzBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0hHDr/TIsw4o3iPK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 22, 2013 at 12:49:45AM +0800, cinifr wrote:
> Thanks. I have modify my patch as you said.
> It is in attachments. Maybe I remail the new patch?

Yes, remail the whole serie and change the prefix to PATCHv3 (you can
use the --subject-prefix option of git format-patch to do so).

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--0hHDr/TIsw4o3iPK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSPiJcAAoJEBx+YmzsjxAgrZQP/1o5mDWx3znAJulWM8tFhQGS
dLHrbc44u/1Ay99U9u+zMq3s9STMzrI87qHMiZqzifRNdaXtSdPCUQ1Q1CApqbA8
33eAWhlIG2VIZP8bTufXVqPOwdUZfqnF3Y1HZj7WxVKLz154wzNtdhithicPDxf0
7u+GHxeppqBFeruCW4CnnDzsyqprPmFwfXNafuWSvsqz9G4K5vVtUTdZc+97hA9W
ZQp07JYFym+RQbivXuW3XCxDWuX7UKZNvMEGFAh0K7dxdKTAYZLYflv6G7uKlOoi
enbvd/CgdGpZi9aAceFkWzqhyvSyA3jOzQYzsIN5jwEAZ7wyFmgx6SD/Y9bpzrIF
99HVKEJhrg3xUi1BufqkBmmxYDMcgcxP1JPk+0cQ0ROeuxJ0//AB+Aq/xayOlHM3
jxOan8LyFqOo0Sf8ppqU8apP78OHdEyffYIbbjsAmM+ERGhEn5aGWcrPy27ywYgt
UDVZk3UMgV/CpqEe1U4wcMxBgQMKmfDhte0EFj4aIHl4ng4l+PbyVEbktk4o0UZj
Tw7MMPLPR32WPIMne1WmZcDw0qniIGIcYUjaDUoBA+dMziwHqi9UuSOx5EPLpwf0
R0uQWUC+Lc6qNP0V4mVz3fPbIfWsJ0ScTNh9nvY3qv5XuP2Z0vhPZ7YKeqxG39hr
kG9LkSd+odo2T0BDK80G
=kXU3
-----END PGP SIGNATURE-----

--0hHDr/TIsw4o3iPK--
