Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaJOOxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:53:02 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59992 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbaJOOxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:53:00 -0400
Date: Wed, 15 Oct 2014 09:52:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <aubrey.li@linux.intel.com>
Subject: Re: x86: Make Atom PMC driver configurable.
Message-ID: <20141015145245.GB11511@saruman>
Reply-To: <balbi@ti.com>
References: <20141015144603.GA19944@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y7xTucakfITjPcLV"
Content-Disposition: inline
In-Reply-To: <20141015144603.GA19944@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Y7xTucakfITjPcLV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 15, 2014 at 10:46:03AM -0400, Dave Jones wrote:
> The Atom PMC driver is always built-in, regardless of whether
> the kernel being built is going to be run on an Atom (or even Intel) CPU.
>=20
> Signed-off-by: Dave Jones <davej@redhat.com>
>=20
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f2327e88e07c..04280177c1e2 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2485,7 +2485,7 @@ config X86_DMA_REMAP
>  	depends on STA2X11
> =20
>  config PMC_ATOM
> -	def_bool y
> +	tristate "Intel Atom SOC power management controller driver"

looks like you should still have this as default y just to make sure you
a simple defconfig still enables this as it did before.

--=20
balbi

--Y7xTucakfITjPcLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPoo9AAoJEIaOsuA1yqRErcAP/ApZYfmNa5R9izXMJD3+6610
SswExKrIBoIE1HZI/Qa70AfPIQtmf7QSSuI5ERNr9GebU82t2bCv1Sqc1GupmI5+
bX/m7q+e2rNu1OTHFAj6q4PcewWBUcAyI566Q3buk/LkuFUBX/jFyLe4KyPF9G5F
fCX4+sGxkK1rBy2+qmtOqwgsTpNHjojr2nXcnOIjl/tmocohhb2EE2Gc/qrj2VEc
Sg/i3/wl65jBBnLn3DEtZ2+ik4pDZ3LM9ijpYQLeKg6JWOxrgbD/zaVE5DJjyPMH
cE8/f7o/ouCUMlfEzdIFcRkQRS80yDXpYyufU/IfJZr1a0PvrVfsM6gkxAp++Zao
JlW+04x5w9ksBPqC+3MenE+JCNZl/4GVlD0rEduxLa4YKbXR0w/+hsro9ykWv2rs
2JnIfWAP34gQ3KaXlhnaPHJ6r7Dlw3K1atww+X9jGTgPwq8DGYo6vFBzGHgeolHO
m9vQDlyYYmfzDtLuLAaQOatk4xua1C2SotPGxkLNiwE0acv2sAaqRVCjhofVNMR9
DB66qZruDbe6xd4XKGsUwgG6zb2RH17lHZEZg1dmy4SBDgGPDfBN3GaSkohNGWPI
dQiVSixsIp0DUeoPj9GPFg3sdPbh4NR472yaLIjfcg6IxjQ5NELU57O9jcjMp39w
0L1hWBY88N8YBfj5WmXp
=F3Tg
-----END PGP SIGNATURE-----

--Y7xTucakfITjPcLV--
