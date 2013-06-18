Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3FRJm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:42:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54260 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3FRJm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:42:56 -0400
Date: Tue, 18 Jun 2013 12:40:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 2/9] usb: phy: omap-usb2: use the new generic PHY
 framework
Message-ID: <20130618094058.GQ5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L0TNCHh3fkwjpuuE"
Content-Disposition: inline
In-Reply-To: <1371113039-5784-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--L0TNCHh3fkwjpuuE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 13, 2013 at 02:13:52PM +0530, Kishon Vijay Abraham I wrote:
> @@ -159,6 +191,12 @@ static int omap_usb2_probe(struct platform_device *p=
dev)
>  	otg->start_srp		=3D omap_usb_start_srp;
>  	otg->phy		=3D &phy->phy;
> =20
> +	pm_runtime_enable(phy->dev);

enabling pm_runtime here has the potential to cause a real big problem.
How have you tested this patch ?

--=20
balbi

--L0TNCHh3fkwjpuuE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwCsqAAoJEIaOsuA1yqRExjEQALZFJUlSmmJ9rF9hBy0KZK2z
hECyUPBrYgR4qtdfH+rmCRpR0gwX7/HwdFeZdvaDOEEjuUdK2MFbvjrb9ldnq3YN
ja6HLcSM/Bhab+AWwjvcsYD5GICN6uW3J7GINIqh9J6ZGbcaIPnhHmfUSq3QILfk
7tqYEdIrdxoGJ3cTgzPiXkSHzQw5payVVcsu9usOWv/bRbEqyQVtogKGbZ5AjSrO
D178HBEq94m1NWwaFRY2GAR7MVxLwco5/Sq+5EQd+mcno6Zcrn/W33FfDPLycaFe
1j8YG8SFRiJ1E8ZjqkJ794HOBvu4N6/2W0afsSBeyrLBdHeasgBeMB9frfibW7hP
KYrELNpnqDQfl0Nf2lx1rvJNYOnNnfuzKPlRkpRv99gqDVQMWQrLHvuAgtiNfno5
SyMD2VPJlP7ec82Lto6yDeGxTTwvBitUbL05dsusC1Fv1+AyudSw3Ll/tWs8OXCJ
EzbLigC3XOUSla1K8EgjKMIDAgr6hukxd0S3j/ZZdwBXTi5aRsxx7bOQ4Hu97i+t
grqXH3cspmCBzfqeTU98o1jnW6qWbtsDeN9nbeekglAfRZyL4mrA35Vweop23oYw
aEysURk4W0gFl2GlSLz1ePHAgg010wlpomxlkmzUXY4udNFSxLEu1Ee/V2iip2Qn
0v+y5zaSmjkfc80sUcKb
=EHFT
-----END PGP SIGNATURE-----

--L0TNCHh3fkwjpuuE--
