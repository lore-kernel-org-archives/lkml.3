Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaBEKkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:40:19 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33755 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437AbaBEKkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:40:16 -0500
Date: Wed, 5 Feb 2014 11:39:49 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: David =?iso-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/6] ARM: sunxi: Add driver for SD/MMC hosts found on
 allwinner sunxi SOCs
Message-ID: <20140205103949.GC3192@lukather>
References: <20140204191648.29809.14611.stgit@dizzy-6.o2s.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <20140204191648.29809.14611.stgit@dizzy-6.o2s.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, Feb 04, 2014 at 08:24:13PM +0100, David Lanzend=F6rfer wrote:
> Hello
> The following patchset adds support for the SD/MMC host found in the Allw=
inner SoCs.
> It contains all the necessary modifications for clock environment and als=
o the device
> tree script modification which add it to all the boards using it.
> The clock environment function needed for phase offset configuration has
> been proposed and implemented by Emilio.
> This patchset is the second attempt to send this driver upstream.
> I'm looking forward to the acceptance of this patchset into mainline.

I have four comments here:
  - Read Documentation/SubmittingPatches, especially Section 5 and 12
    (hints, you forgot the clock maintainers for your clock patches
    and you didn't put any signed-off-by tags)
  - You ignored pretty much all the comments that were made during the
    review of the first version. Go through
    http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/219=
339.html
    and address the comments that were made.
  - Each of your patches should compile. Fix the order of your
    patches.
  - Submit a v3, with the changes you made. Otherwise we have no way
    of knowing what have been fixed and what didn't

Looking forward for the next iteration!
Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS8hT0AAoJEBx+YmzsjxAgRR0QAKqkCdwusxTRAK63xejPuXyV
u1beyvWAOP09eGQND3kpjFZuaq2LedqG2avBtVqC4GSbIh89akWVDhr6kbjkOoPu
3VaTqtkN5FNoQ8bfS/PJIl3S72p+DBku5BOkT+yNcLiDPNkyc0RnkR/mTywBIMVd
671eJMuS/jV8jacROOuyAQmFfKwKjl6Y7S7RMNTMmR273XM3znpRU4U1i8ir4mPw
N8kMOc0yK1FZ7t7zibckhnpCf7Y0Mb/UBjz5l5rd2prwoqtMkhGhHwlSnA8J4YK9
szs4iY4cH+4wwsPh9pFNVooIHEMFIjL+MgwGls1ovwnDLmQKfzFYogkSltCZeO0B
SJgd02wagzp/X/4te5iJ1kOYODp8192bVSICIPtCvLRKbBvJq3cGSY8UGj0GqUr3
dGXRqomhzE37AOc5tCe7Wdssu7qxjhn5KlqyOqdvZlMjxvI2s8TMKzNgARpku93M
wMFcQ5N+Rw9vdH0QwqCVxXS6v+2PP8gm4bQC/X4ToWRUjBs5oC3MJOdrUkn+QI5I
1TlclebP2lcXccgGBOqEUAt6mbXHCMayEiISxPpHlkZTPENSibms2lzpOGZVyuwp
SiWTHOiHsjJSdP/81ZLLW+sY5EIgW0xNIVhIHEjazNjx2znEteCFVSnSYdU3YMRb
3Kl9pTh9i5KW3VBzC81j
=74X7
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
