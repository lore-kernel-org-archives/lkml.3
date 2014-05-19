Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaESVI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:08:56 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33510 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaESVIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:08:53 -0400
Date: Mon, 19 May 2014 23:08:49 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Tony Lindgren <tony@atomide.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCHv2 resend 00/11] improve PWM lookup support without device
 tree
Message-ID: <20140519210848.GF30737@mithrandir>
References: <1400532162-29483-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rWhLK7VZz0iBluhq"
Content-Disposition: inline
In-Reply-To: <1400532162-29483-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rWhLK7VZz0iBluhq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 10:42:31PM +0200, Alexandre Belloni wrote:
> Hi,
>=20
> Originally sent on Apr 14th, note that this series is blocking another 16
> patches series, I would like it to be taken in 3.16 if we can agree on th=
is
> implementation.

It's kind of late for 3.16 now, but it doesn't look very risky from a
quick look. I'll sleep on it and if I don't feel too uncomfortable about
it in the morning I'll apply it for linux-next and see how that goes.

Thierry

--rWhLK7VZz0iBluhq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTenLgAAoJEN0jrNd/PrOhJQsP/1C09qs8Y85T+8vvFJH8yWyU
IKOd3JKjimnPqBXZsa23U9aFr8lBJCFyQGJGayeXTJNw1ql3Chu0B4+HQSbUNOCD
/3a70J5GnDlB5GU2KOq2i9tfT4/m+Bv3s+3maXB+As6m09ksmt+shO9+kM+NrmGC
eqX9IOmCKxnbd90vxPCSlgDXQ1jFTcMShwDwaG7iU8rS3aUSHLIaeL2K2Dh10l6R
1e0ivk4dDWTKxmje9Jq62hlw5BeC7EDVJxtv1bf4HftbHRfbcEVw827Ff8ofnqzF
If/tFKqm61AtJ8qlfzjdV35dGSd4B3Qm+dh1ZZPQPz45aIzbAi6/jFss6Xcf9PH6
hMsWJPPrfptfrKWm83kx9ynLHjZgv7zpNztsDh1sZ5pjM73bzfBkCEvu1Mau/rRx
ZCzgQfUafoH2xlgrShl0c70MZ3qJuc0OLMTSXnxwKwn4TwlWv7Dg/DCHjIgoQBAS
7trJhhQzhzMSPeVE/kIWQLv0c9mt/EuGekFL7rUMECIYIzZaK7HESERFatk3ZhPI
/QlzAsLaHA8+J4G674aTI20jiAfkhkFiUCDG6LVmv2NTWF2ean9fDpsJrNSv4voX
lcQnw2vbnSRvMCHX4PG5F29Mg/Usl76qQAmndN22831gWa5ULfP6Zo7rac0TSJJu
ABlXVGZkZ8ncXuQzKF85
=WwQk
-----END PGP SIGNATURE-----

--rWhLK7VZz0iBluhq--
