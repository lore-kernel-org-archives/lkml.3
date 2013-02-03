Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3BCNPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 08:15:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33393 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab3BCNPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 08:15:47 -0500
Message-ID: <1359897327.29976.4.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 38/89] ath9k: add a better fix for the rx tasklet vs rx flush
 race
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 03 Feb 2013 14:15:27 +0100
In-Reply-To: <20130201130210.260645970@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
	 <20130201130210.260645970@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-AlS1E3hS5sVsh486Qkjf"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AlS1E3hS5sVsh486Qkjf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-02-01 at 14:07 +0100, Greg Kroah-Hartman wrote:
> 3.7-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Felix Fietkau <nbd@openwrt.org>
>=20
> commit 7fc00a3054b70b1794c2d64db703eb467ad0365c upstream.
>=20
> Ensure that the rx tasklet is no longer running when entering the reset p=
ath.
> Also remove the distinction between flush and no-flush frame processing.
> If a frame has been received and ACKed by the hardware, the stack needs t=
o see
> it, so that the BA receive window does not go out of sync.
>=20
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]

Are this and the following 3 fixes required for earlier kernel versions
)3.0, 3.2, 3.4)?  If so, could you provide backports?

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-AlS1E3hS5sVsh486Qkjf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUQ5i7+e/yOyVhhEJAQrY5w/+PBYM7ZXA45VMAk/y/BN8MSUw/l5wyVFP
q5eA4ODs8+AFQ5pEz1sC9uKsakylYwkaeWg7o4Rl1PslZYw2+ZjZhfM6tGzmO6fp
NTNuMJCNSbJ4n2PGV2DefoVZPqPmA6YvpZuSh7FgC9fTkzG1Dm8PwJ8YDsgkzQ5m
1sQ0CbT0jXIXopSSzC/SvCZ18P0f/uMxH1sJaj9Ix8eOtsABsCFEcr+2InyRHTTD
ECl8cC+SMABU4ayJ7VYDmlD3E1qRemJHqZM79RHAb27pQjN28OYBFJjI37S1aUq3
BF0jLYLnFa/52ftmU8aSmfgKFjK4xTygyx3eNQQLHH8ybR8N0xuquDBoDmzKiZpX
gK5fDQHaZVPOiM0B+P/Ijdz7mVZdGbGXhHB6Zl8WAXMyvoF23I+TFPFVmMhFM0OK
oK8/xaKH4yr6ab/LSyFBLq3BjsD36kI1Zq9XT5pNntvwu275tW/vfnc+iPzmY7a2
EGi7zMZNWHque6kHMKHaZJnO1JtpP/CXH/mP8f6gduTPnMJhmxBvAA2LJYEFT+C+
/e2yeAPc9d9VlRLKBPz2phIxmro3hZepdqkJJu8s69fzWwTVG6AYP8cZA/P5/yDg
MypwT65ufXpUPWJo+SBWdQiKTZPFBO2y4LgzZJTlb1sOnKGJnnrsaBwwA7jrUFi/
ZhPLSsgr5HQ=
=vKOg
-----END PGP SIGNATURE-----

--=-AlS1E3hS5sVsh486Qkjf--
