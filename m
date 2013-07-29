Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab3G2LkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:40:08 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:53674 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3G2LkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:40:07 -0400
Date: Mon, 29 Jul 2013 13:40:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 36/36] pwm: convert class code to use dev_groups
Message-ID: <20130729114002.GA23152@manwe>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-37-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1374703539-9705-37-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2013 at 03:05:39PM -0700, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the pwm class code to use the
> correct field.
>=20
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>=20
> Thierry, feel free to take this through your tree, or ACK it and I can
> take it through mine.
>=20
>  drivers/pwm/sysfs.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)

Applied, thanks.

Thierry

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9lSSAAoJEN0jrNd/PrOhuNoP/1g6QGrMFM/Rd3KJ5RpML8lY
vusrNiMTS/1EjtilTD6yDXLTcc/bg12VA5rGmzyw8cRyyP7cxEUCetOLT2fRG0BT
gbIx23M0lhjJrzl9GQ4IRLUAdgtQ4wFsZ8w4jZfnp65VvpmTJc4jTY2T7iD1e8Dm
WLLoiBKkhaEg1PpRafv/GiwWX0HVU2cn2GiXznvtB9ulo+mWZRoo0UQfsMnTKbSH
R4XrWtA1NTIMwElwxFRfIaXwq4AvEFPACRhs8NgtHwXRfmRKaC1J2/d4tJQvgqwg
A4CP4zglyR81g9fbWTZUAZLoRwExK1FC5M6u7j/1uMbh7jRpsRDgtEU9BdiTyzFl
p8AeaWS33JdYs0/AgzGf+aeynQPtS4p00KUyvxjYZ8LiImFGb4zfaFMQDJomEEJ2
6wgc+ZEW1zgIe9efCgkzmlcVllzOKzOcrhb/5cIsO5RkERkZs9dn68SlhezNK8NP
MJyY69rJgwoJHAIbWbD9eSrEUFsB3qGiSq+PAN3roqloZLkL6ezk1xsLkwc63Mhg
+DWVG6k4mSJmmtzytAAs2IEaw23YOWjlRRGWEWXo9/yAWJDrjWTgLCqnMmLfIRqo
4fB/zJa4HpAnT1jyLMzoq1g4JpPTWA2LTtda2tzZ67gYcDrkObhUd0YhmDbcT0SE
ACHdt/G0Hs+dCedzEH6/
=MNT0
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
