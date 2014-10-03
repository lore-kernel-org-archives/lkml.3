Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaJCCgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 22:36:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:54792 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbaJCCgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 22:36:52 -0400
Date: Fri, 3 Oct 2014 04:36:46 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Feng Kan <fkan@apm.com>
Cc: linux@roeck-us.net, dbaryshkov@gmail.com, linux-kernel@vger.kernel.org,
        patches@apm.com, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/1] power: reset: corrections for simple syscon reboot
 driver
Message-ID: <20141003023646.GB6361@earth.universe>
References: <1412274255-1315-1-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <1412274255-1315-1-git-send-email-fkan@apm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 02, 2014 at 11:24:15AM -0700, Feng Kan wrote:
> This patch is to fix some bugs in reboot driver. Which includes auto sele=
ction
> of the MFD_SYSCON for the driver, use of container to locate restart hand=
ler,
> correction of the count down failure timer and ordering of the header fil=
e.
>=20
> Signed-off-by: Feng Kan <fkan@apm.com>

Thanks, applied (incl. Guenter's latest suggestion):

http://git.infradead.org/battery-2.6.git/commit/afaebbdbd48ada5ead707d6a90c=
e4b604e1d77d4

-- Sebastian

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJULgu+AAoJENju1/PIO/qaU/wQAJNhuvtfqGeUs/CWyBqwuLgc
Tn6G+ZGq9FAQFnSK0udvmd5dI8OtjtC3nwdhuH+GYwr6OTEPmWzUDD+WZn3SwIs8
0CBRBqXe3tebZuxPE64jHXiabTGAvuBQ4FBS/YQYMI2FOAbfX2r8bsVUcvBm0zJq
q6Hfxqnh2c95+3AOnN5n2KBl6QnedVq2bGsrdUkylhfyjsM9LDb9YvDnzXzAU64F
iMWeu18Ok+gKzTRfral0OtinDVAQ7Sagq78nVLPHvMouXADU2Rl3amK+aBalE/PI
1S7U1q5kuU9LyE1LyzwbgUkPiu/D41s97N2UsivGTT7JkPBwbQ8cteYH0TiFHqN2
ldXZo5rtxW2mZ+RsvkZ/3MSfexXcFKAdTRG1y3KKhIdJFTgWV/bYrguuVSHaWGoe
ZUZZdaLaniFlkxTCR06f+8NGxsVX3bhWMtdZE9cj3uODim2E3Otsq/0zZD/4PXiP
LwTLYFmoDCode1bQS0DhpoUzMxSK8CvT15HS8EwxHu/QGzKM3qOuLKgQ5rmFiOZs
gbyipXdzgcYXAh6Rrzqz2GQMIJ9hk3SloA1gQFN8kydQGnYjYOBdWLVZ/Skduf6Y
EbyFEeO9p/kdZWInk0WkZH58u1px19D5iBMdDkiX+D00+HuJfnIWtcCl8P1kivUZ
DxY2k94fLMCydgv6P/0O
=jaD/
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
