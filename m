Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033Ab3BHODU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:03:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49130 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758353Ab3BHODT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:03:19 -0500
Date: Fri, 8 Feb 2013 16:03:02 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 08/10] ARM: dt: Add references to tegra_car clocks
Message-ID: <20130208140301.GA23979@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360330602-30472-1-git-send-email-pdeschrijver@nvidia.com>
 <1360330602-30472-9-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <1360330602-30472-9-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 08, 2013 at 03:36:40PM +0200, Peter De Schrijver wrote:
>  	tegra_car: clock {
> -		compatible =3D "nvidia,tegra114-car, nvidia,tegra30-car";
> +		compatible =3D "nvidia,tegra114-car";

trailing change or intentional ?

--=20
balbi

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFQWVAAoJEIaOsuA1yqRE8VQP/jb3s4240ftU0ywaW20Ums3p
+YeWH0qJJ+fj3qF5ZjOAYZSTYBTvaQRzlZiqG3dr9vzd+IsC1D2d9USoBb/jddH4
cFA0HXB0v7dLyweSSA1v87Mvuqv7r3CxJNvdrw59GDbx5aHHFGZcP9MmM2lEsyv5
+KbQ8Fbs5OZygDQcybUjMlyl5K4pFsLa/F6mafMJBYBEbu3BJ/Ve54BkPuNrpjDQ
+rdcJ9LJG6pjGy0XbftimJ0C8oRsH/vgQoZOgPcsbpYMSAuRz8wHF7lBnU9SS7vt
UdY+4b7BRRTB6uZFZ3pWf74U7h6cRJ9iSimVD1ziHgWofHnUtCVDmohieiRRqG5H
/GKYFMpba6VEBQZT6As8Ir/dG8lwechuMIUlMoM0WG9CAcfEe7FkH3rTttjE0OBz
58+rRHJQdDcDzyWti0Fzf47zhLKYVCxT2D9dA90ILwcZ6epiRtlAbk5KjSLamKHk
AExrSCjEevVqoBzyfYl9Zu1EliTfv8L93MBbTIZyIDuAKREU+wGrAf5Har6yyo+q
uFO276w4HeAFCJruHqHAFc2Q8zc0d8+jI5HOwHHzcSyMOwtJ9Ya7O2jQ5jWXQbYt
Mvr+MF+yvjX+4NlHRha+bGA+jwRG8c33TAgoikzEcxfm3xkUNz/xWtvEskfM83V1
I/u3NU2eVs+hhWpnY7XC
=Lbll
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
