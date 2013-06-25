Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3FYPUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:20:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43532 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab3FYPUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:20:17 -0400
Date: Tue, 25 Jun 2013 18:19:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>, <balajitk@ti.com>,
        <george.cherian@ti.com>
Subject: Re: [PATCH v8 4/8] ARM: OMAP: USB: Add phy binding information
Message-ID: <20130625151928.GI21334@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372139926-3719-1-git-send-email-kishon@ti.com>
 <1372139926-3719-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U3s59FfKcByyGl+j"
Content-Disposition: inline
In-Reply-To: <1372139926-3719-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--U3s59FfKcByyGl+j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 11:28:42AM +0530, Kishon Vijay Abraham I wrote:
> In order for controllers to get PHY in case of non dt boot, the phy
> binding information (phy device name) should be added in the platform
> data of the controller.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--U3s59FfKcByyGl+j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRybUAAAoJEIaOsuA1yqREBxwP/3T9VkuiRZaE+ZvjOq6pA/sw
RqXemkHo2lEL3tg8dQs8R5E4ILxUizDQh0rL0Xet6m6bJWCKxVnfd9miQH0tQfIO
I1ZpocVWhbrxEbvhuqG3KrkJM0bb8/gkpfnat1desSJYFxoUnnFFeNr4rFCHWBqT
gdRqDfzNBNzQfN+6tVH5SpRgsi2RTtLeB3pejVCQxU31m0nGMDT/QJP59hxO26+u
4/fdePQrC9dgmAZ1Q34HH7PAjDbA4oZlDZYNl50S39rzOpklo4Zj+lyWkO5tMXLF
9o1zSJL086P60AG2x36sxu8r9492wBlMYYTijHEk1STiWvi+mwtRtBIxwz3QnSNQ
83zW4Yz66GAtnjFQbOSfQSx16ogHm6pzO8qsbJ9GrZhBeD4A5Ru35nhiA5hcLkpS
1Kr2MJmqIS65i+EFgADIhaZQfbG5KGFakmkZbRB/Wvix6mpk1+LFc0hb+xSl8zb1
6p2bU4EPgU4+/WYvZIUxXnId5xcH8qlmhiVEAsBiaPBOe2UzqLGVQOckH31mGB4e
HgE+pw6Rva7glA/P/RBWj8GbNgJEBLjUYsbYJUc0+ylJ2R2CdaR5Dw102opTCWso
3H9oIaktizlDt3u3z/QasjhhlOr0sj4Jeb9KOGnP6N/SI0oaWg/LLVLYNpn8S2bp
A9TfVb2XMPtlt6RspI/D
=yZxw
-----END PGP SIGNATURE-----

--U3s59FfKcByyGl+j--
