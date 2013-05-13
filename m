Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3EMSpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 14:45:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56115 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3EMSpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 14:45:08 -0400
Date: Mon, 13 May 2013 22:44:43 +0400
From: Mark Brown <broonie@kernel.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130513184443.GC14811@sirena.org.uk>
References: <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
 <20130510212422.GY3200@sirena.org.uk>
 <7e18bed3-ae6b-4aa0-bf23-b6c61ba8b85b@CO9EHSMHS030.ehs.local>
 <20130512143344.GC3200@sirena.org.uk>
 <9e55c552-ce34-4663-9a57-bf2c626d7d58@TX2EHSMHS008.ehs.local>
 <20130513052135.GD6836@sirena.org.uk>
 <0bf5a185-86f7-4a93-a90f-42caefb06a1d@TX2EHSMHS009.ehs.local>
 <519112F9.2010102@gmail.com>
 <20130513181625.GB14811@sirena.org.uk>
 <51912EE2.6040909@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <51912EE2.6040909@gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 13, 2013 at 08:20:18PM +0200, Sebastian Hesselbarth wrote:
> On 05/13/13 20:16, Mark Brown wrote:

> >Yup, that's part of it.  Though I have to say that if all we can do is
> >stuff a bitstream in there there is the question about how anything that
> >does require a real driver gets that driver instantiated...

> Back when I played with Zynq, I remember looking at CONFIG_DYNAMIC_OF
> discussions. ;)

Which then goes back to the whole idea of this being a device - and
possibly that this should be done as part of representing UIO in DT
rather than anything else.

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRkTSTAAoJELSic+t+oim9W88P/1nCJh/oM9ky//kJYJ8Xhpur
LRsgojkScJ2jLE/H0vFOk4ZVB6WPZiu+E17p/7ALGEEKsX1sDtg7/YZPiN+r/VXq
uPJ+nQ7U+2D5iQAoIzlUpcwI7Z0/q/+HyxWVoC77V4in1cRAPVAANPSNVdYn4Sw3
1Zsg0ndLaBEEaNAeUDuhVkOOK0L64HA2JpwHZvGZtdW8uw6Qa6kCC+7/E1m0xJbV
yt6qEyvl4qum+JbKxu8c0WvL24Dr2Fd5wrlhFJyhy13ylxB9qTfxhzeqVuT7HDdO
n90yb1QDv2hey3of7m1INMiiK7qaMwnMWxff+rzMfu3mvYYCKZh6Mgk7QWTJW32E
ilgRz/j/AVZDmIfqEc+W2IAWVSMiSA3wZZPZB0wOAMOXmxx3VxxSC+tmP9c2Rs8T
UqzDeK2eb/+qtKmVWrt3P352C8YL0FQpazbBKPC1S3z33HZuwU8TywXOdQyvkEso
3I4LJbIzw/XU6dKbrVPPgVRHM+G31OCBXduUOLclJJevDIjvhaT8+MjZIdsvglPP
LFhVnBCKZ7F4q0aEslLdyJXY1A5XMVcpE5/QURouPQbFekUA34scDiBDpe9jS403
mVH3OM5dQu7InNNkocON8jPA0tYMxR4MpHJZfcamvsdBLga42Ubjjdmr+9p1jbkJ
A7dZfy7DGvam22+gef1g
=bFwk
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
