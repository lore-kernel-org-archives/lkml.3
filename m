Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaKQMlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:41:24 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:40502 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaKQMlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:41:23 -0500
Date: Mon, 17 Nov 2014 13:41:20 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Scott Branden <sbranden@broadcom.com>
Cc: Ray Jui <rjui@broadcom.com>, Arun Ramamurthy <arunrama@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] pwm: kona: Drivers fixes
Message-ID: <20141117124119.GK25699@ulmo>
References: <sbranden@broadcom.com>
 <1415989800-7515-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9kwpIYUMbI/2cCx"
Content-Disposition: inline
In-Reply-To: <1415989800-7515-1-git-send-email-sbranden@broadcom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9kwpIYUMbI/2cCx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 10:29:56AM -0800, Scott Branden wrote:
> This patchset contains fixes for Broadcom's Kona PWM driver.
>=20
> These changes fix glitch issues when changing settings on different chann=
els.
> Kconfig change made to allow the driver to work on any Broadcom SoC rather
> than just mobile devices.
>=20
> Arun Ramamurthy (4):
>   pwm: kona: Remove setting default smooth type and polarity for all
>     channels
>   pwm: kona: Fix incorrect enable after channel polarity change
>   pwm: kona: Fix enable, disable and config procedures
>   pwm: kona: Update dependency to ARCH_BCM
>=20
>  drivers/pwm/Kconfig        |   2 +-
>  drivers/pwm/pwm-bcm-kona.c | 112 ++++++++++++++++++++++++++++++++-------=
------
>  2 files changed, 81 insertions(+), 33 deletions(-)

Can you please resend with Tim Kryger <tim.kryger@gmail.com> in Cc. He
originally submitted the driver and I'd like him to at least have the
opportunity of looking at the patches.

Thierry

--M9kwpIYUMbI/2cCx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUaezuAAoJEN0jrNd/PrOhpXcQAKHTzSes6/8SZ0CBSH6wj+XE
zlfHVnUrJduwfLvUErOpW/S5SE82c4ocWvypQ6bgdAeeTicCXf8p2tXAYeK55xpG
tYQJoC+k/3XwqOcQvd91m2eslRHdHsTnF5ch0QBjBxfTjwGEOW1RMA8C3MPf4Ea4
GCRmFJh25VfoCn29lzIwKQ+qzXcqc0UaDrUdR6Gmf1iTrAu9DG+zwPsIJ6JjRhh0
Ni+nWiyH7Wm5gABG8jWVlI3kH477mSafQpv1YoTQAYapVzWVumfmgC7ySol1ZNJF
pwsIYK4wrokfyfjHOF5ynkAMlM7yua1DO2CJUe1AU0nlqZRf36k2c58GePsaW8nj
gS4CIR/f/hbZDFD30GVc3d4h6Y+ecQL9BBnf1IF/5lOrSseKMZZOM/BaFHznG6q2
sA9dIuXS9JeIkWAVIVXse7ED6GL3rHjTN1YAptXuAp23/RZuw1MoO75EP2EYVrbP
1TDuALFMoh5ieOrO3SElpArHm22cDQX1c6r2v9NG7HH/pc1ni4F/o9lQAKShxy1M
LNDb8m1tx4nC4mYopyASsclQNb1d/JHE+0GWs9klKV92h/Bf9Uo+gOQ7vw0IcdoK
add2sys9LmuAEqFTiTBc9abfynoAkSY9v4yf7S3OeyeUxVsfooiOXDvhdLSaGnHl
JLnIYLz1D9NIOT+U48CT
=MnuZ
-----END PGP SIGNATURE-----

--M9kwpIYUMbI/2cCx--
