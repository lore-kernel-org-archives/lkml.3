Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaGKPCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:02:34 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42850 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaGKPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:02:32 -0400
Date: Fri, 11 Jul 2014 17:02:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-pwm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] pwm: add Rockchip SoC PWM support
Message-ID: <20140711150218.GC6523@ulmo>
References: <1403360528-12757-1-git-send-email-b.galvani@gmail.com>
 <1403360528-12757-2-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
In-Reply-To: <1403360528-12757-2-git-send-email-b.galvani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 21, 2014 at 04:22:06PM +0200, Beniamino Galvani wrote:
> This commit adds a driver for the PWM controller found on Rockchip
> RK29, RK30 and RK31 SoCs.
>=20
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  drivers/pwm/Kconfig        |    7 ++
>  drivers/pwm/Makefile       |    1 +
>  drivers/pwm/pwm-rockchip.c |  177 ++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 185 insertions(+)
>  create mode 100644 drivers/pwm/pwm-rockchip.c

Applied, thanks.

Thierry

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTv/x6AAoJEN0jrNd/PrOhD5IP/i87rwB1uak/S2rChBuCF73Y
0L3n63Ghvriq+1y4esla9+yOTMW6TVA3vAxxn24TGMYPW3u8F66KYYLVP9RVcm5i
24RuMVe6PGIxISw44jLbLPjMyanMI+4EoBMS3ISn/1zAnDnt7+nToOH5IOD6rRLX
ISoLF3f7iruEgP2968O5wcD2KA8tDiy7HLbN2yymHgba8ONyB2glrj26LuZcy738
wRjmTwd9A7PLov6B1h5BmC0wEl4zn2r5XUrFkZUfceGQyb1WZRDJHr8eh/Y9w7FJ
VTDGwTDi5hA52xeJbct2o20QwueqFM3Kxarq0Utd3dRotw6UI//4TQwHOSa7Y7Jp
Rr3Fcx3tywW9GgSyuJhFvesKRKHd9EEY1Ty+xN595SnustrMDtCgYQP+N7IGfzVg
l8eCL1402QRqCmjvsUTfAumijLzvF9HjYOX4+fBgKZiC8EiXZOugjfbD4S3FuVGI
VAkWWerSzrUCSGu56454amPZJmN2sBglPGx9EFEhsRhjYkTOGGV20wtt4VvWII7i
lAN0QS1emZAlwgxGp9LrCNCrrDX7w10cp+CK0vHQ2VdVBEcCYj00GGwridS1c8pM
xENmPQCm+eFNXG1Uu9jtXRIiFKSuAoQhVQAIGBmPrrjO2ALCIsGVNOQmzd1ToIjB
IW/2oPfwkXzx6gDvfpc7
=e3o9
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
