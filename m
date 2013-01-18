Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3ARR7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:59:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47454 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab3ARR7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:59:40 -0500
Date: Fri, 18 Jan 2013 19:58:11 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Venu Byravarasu <vbyravarasu@nvidia.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] usb: Add APIs to access host registers from Tegra
 PHY
Message-ID: <20130118175811.GD1035@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <Pine.LNX.4.44L0.1301181029350.1988-100000@iolanthe.rowland.org>
 <50F98646.6040209@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <50F98646.6040209@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 18, 2013 at 10:28:38AM -0700, Stephen Warren wrote:
> On 01/18/2013 08:30 AM, Alan Stern wrote:
> > On Fri, 18 Jan 2013, Venu Byravarasu wrote:
> >=20
> >> As Tegra PHY driver needs to access one of the Host registers,
> >> added few APIs.
> >>
> >> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> >> ---
> >> delta from v2:
> >> Renamed USB_PORTSC1 to TEGRA_USB_PORTSC1.
> >> Removed tegra_ehci_set_wakeon_events() and its references.
> >> Used standard defines for accessing PORTSC fields defined in ehci_def.h
> >> Included OCC bit of PORTSC as part of TEGRA_PORTSC1_RWC_BITS.
> >>
> >> delta from v1:
> >> Taken care of RWC bits, while accessing PORTSC register.
> >=20
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
>=20
> Felipe, you said on a previous version that you weren't sure if you
> could ack this since it means the PHY driver is touching EHCI
> registers... I don't think we really have much choice w.r.t. what the
> driver is doing, since it's driven purely by HW design. Is this updated
> patched at least OK for you not to NAK it, and hence I can apply it? Than=
ks.

Sure I will not block it, please go ahead and apply it through your tree
;-)

cheers

--=20
balbi

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+Y0zAAoJEIaOsuA1yqREGFMQAI0CpFhyjcZ/jeQMajQnAEm0
2lzA4ZjTjTp/GKRJixsuVoZSkRfoYFup2RPiI0RucZ5Yric5oXEQOitauFDPdv29
JVo+ucWAT1qbxL7ArUAhITcPC+3sgx3TaFREThwEAB1QpKIJwLAFp2M0FLDJPj9R
PBESTmc2wLD+vy58CNDonuIv6A5Yi7S+QRXlHfrXsNHQD/zgWnAAdaOldtbpttIQ
6v17qM45ionipEfuvk+O4HHBT4ZN6dJA9jygHnHgBrbfrukYBPTcR2UGtIVRfoEn
0+6ttAOuQSIpNnaHhpusxZHtOEggzNLoNBmYgdbaqZtfdDNYnjTQnyr5tFV6LpId
vopHx4Py76eVCGdq4gskI9wDn6+WG6288+APo3SdgkjbBSFyYELpq4eFDPqc7iOT
8oy3DeV/8w8M1oYXDLL5eXwFLc7CSXEwCHv372jTDkNzwlhMW5c7Rxz9cKYvCv04
ieq6oABOA3a4a7Nvf3hdKDUXNj9g0AkSV57ITkeoLdNkL/3gWBy9yFZmsGgp/3l1
XcOv2R/WjIq4szimJJQ63eUpCKokOLsByWlFHtQXwM0RQZR/FL/1Ww/hsjOsp4P2
Zwl6d1KdrkfB5N50KQXHw7jzxgbWDQ19hISl8ic4hLipMdNsUK9sZc9k+TPJtV1w
bVTxdTN9iV2mHFrL6wc2
=SDN5
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
