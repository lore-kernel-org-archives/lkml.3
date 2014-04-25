Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaDYCMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 22:12:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33988 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbaDYCMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 22:12:37 -0400
Message-ID: <1398391948.7767.182.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.11 052/182] [SCSI] fix our current target reap
 infrastructure
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        James Bottomley <JBottomley@Parallels.com>
Date: Fri, 25 Apr 2014 03:12:28 +0100
In-Reply-To: <1398329507-5911-53-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
	 <1398329507-5911-53-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-lABK9Lk0+hkX6P89T6hD"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lABK9Lk0+hkX6P89T6hD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-04-24 at 09:49 +0100, Luis Henriques wrote:
> 3.11.10.9 -stable review patch.  If anyone has any objections, please let=
 me know.
>=20
> ------------------
>=20
> From: James Bottomley <JBottomley@Parallels.com>
>=20
> commit e63ed0d7a98014fdfc2cfeb3f6dada313dcabb59 upstream.
>=20
> This patch eliminates the reap_ref and replaces it with a proper kref.
> On last put of this kref, the target is removed from visibility in
> sysfs.  The final call to scsi_target_reap() for the device is done from
> __scsi_remove_device() and only if the device was made visible.  This
> ensures that the target disappears as soon as the last device is gone
> rather than waiting until final release of the device (which is often
> too long).
>=20
> Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
[...]

This and the next patch were commented "delay backport by 2 months for
field testing".

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-lABK9Lk0+hkX6P89T6hD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAU1nEjOe/yOyVhhEJAQqGhBAApN1j79bhNgLZb+jIXezthszAp2MkQRsz
PYF5Vi/rDm4c+K/Khto3nox08WJban6mp4Fwy24KVX469ID6krXU41176Pms+E2H
nvN1Y6ys0Vi1oEZ80H9XNvxaTeCaFueOUSy3esEvdmakqTCx7IfryHaF0vKmOURg
zbMMgasS7qZphfrSB0mHZA6MdXkEjGtf5oF/Ze0YLNiXr5gosN8oHkHHxccfZeom
w005PzCevoLavmNItELztdv51oJI6H8d6BP4hjB9SfcXNqB4FtAoh4Gg3/Udr+Xj
M6CIJGYF/Nxhycn2ZJ3ia0osrBjCs+RYtGLvV8xBzz5QUp3ihbUPdbqA9xJAbwT2
2OG3yuzyTURjlrWo3gcQXOf1ah8Nr/SkSu9YBfMtkp4hnJ/Y5ixq5cXqnP5WHXwm
bgLWMOAVo5j+I/vFErJt/uBl33PckaDjixkT4OvooCvMU47B00njUN6cmch88wKx
kyeV/F5qwYbBiWsGyOgDIU+3RwUnuF4G8h9GxgUzf6Q92OjlEoy2YUAf67wcTkWy
Qjtol+IiIFHCR/vx4e9LTSphooyXfxfHUVVVBNyfix6S4qyOmBNWjOm3LKMFUSIS
it0XeEpOsG4v4xx5p0529DFlCQuFj5dl63j2cr5TFllVNWMlwH+PjwwCn9VrW98l
q+FlRTRcDUQ=
=9cUu
-----END PGP SIGNATURE-----

--=-lABK9Lk0+hkX6P89T6hD--
