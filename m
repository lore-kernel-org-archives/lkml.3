Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3L1NQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 08:16:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:39123 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab3L1NQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 08:16:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,566,1384329600"; 
   d="asc'?scan'208";a="456887562"
Message-ID: <1388236566.2183.191.camel@jtkirshe-mobl>
Subject: Re: [PATCH net-next v2 07/20] net: ixgbe: slight optimization of
 addr compare
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 28 Dec 2013 05:16:06 -0800
In-Reply-To: <52BE6CFD.4090403@huawei.com>
References: <52BE6CFD.4090403@huawei.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nJsXuLQrGhIQ/tJhlsLz"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nJsXuLQrGhIQ/tJhlsLz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-12-28 at 14:17 +0800, Ding Tianhong wrote:
> Use possibly more efficient ether_addr_equal
> to instead of memcmp.
>=20
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Thanks Ding, I will update the patch in my queue with this updated
version.

--=-nJsXuLQrGhIQ/tJhlsLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABCgAGBQJSvs8WAAoJEOVv75VaS+3OJUgP/ierLojo4L7lWwm7SkiQcc03
RVmLYhvrjayojyZI7eiYWzSujoB7uPjJuBCgeJ/J1IzCzDZ/UmIOZLsoM77zU9x7
0wtINZ5I+wRGIJ1IHBmqYtwEFk90Pb6fSZy3vnydgGSDMhA/D9gEWmUOxkDg5ygk
SgfGNUaBVxNyRU3uj/UA8WoKqDj87Ibsxvl9AangoUByvlGFVPgyQixe2Kzof4jw
ujeK7ooe1h9WVfqOfdIfuKegjyVmzmr3YFn1cyEIc6KjcOxDgDlmbWBCayykxKC4
4gLIOIEKQCZuBIc+TfkK14D/rehO1hVIr5YBvHUUSGqsDc8J+/aQsDn89vm3i05e
AFe+ww+Js7dOj0uzaeDchz07q7SKastYDBaoegrg77GXzNDlI4TNSMAMQN7Z/Ix+
fv1/CQ8wZo1pRBZFam6Cu516qA72/g7P9Aa+0wopiISUZ4zV3vM77KOCcMxwD24r
tKtmjdgk1anuIbnyX23OkUVOCEPivqNM0D3pK0dSNg4DhY0ls+izzJMR08295cR7
U15P1l/pT1ck/PTwuJcUEcM89IFOL7fK2Ix0KKKVdZJGLskAU15048gvp0Uqs4k7
3rXsNVIfQvwh9ocSDrkzwSNOdvyCu1FWvAzAL8eVDMLsigyhR3vK1kzp58Xdh0wI
3lilYwm4TlKM0L78+1eL
=TnP0
-----END PGP SIGNATURE-----

--=-nJsXuLQrGhIQ/tJhlsLz--

