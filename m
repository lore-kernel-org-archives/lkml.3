Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbaDXOKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:10:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42708 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788AbaDXOKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:10:50 -0400
Date: Thu, 24 Apr 2014 09:10:29 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCHv2 6/9] extcon: palmas: Use devm_extcon_dev_allocate for
 extcon_dev
Message-ID: <20140424141029.GA26661@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
 <1398081742-24277-7-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <1398081742-24277-7-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 21, 2014 at 09:02:19PM +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
>=20
> Cc: Graeme Gregory <gg@slimlogic.co.uk>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Tested on OMAP5 uEVM, please remember to fix up ordering in your
extcon-next branch to avoid introducing a non-bisectable history.

Tested-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWRtVAAoJEIaOsuA1yqRE/2kP/3YYa7nKX0Wd0e5tcjC1zMMv
ix1KSWJQeaKbG2hOT+PLV0S4mf0KrccHDEVDYauCIVpY0vXYq1HvGxXTJgtoulE8
Jz4TeIOVR3q3j0czzvoDV8amhsjEgS67dUqXHaLxw/4bH0/RycMA9la/B687G7fO
9J53H77h+bZ24DFePF0b/l5Z00PLPvqvm9vxb6hCQRdPTbz9PX+erxGVhAeBXD1M
h55BVtz+dDWlYqOoGg/ppN3HTReNeRy6bafnuvsJUy6xx0L6SukgnqbF81ta+Nfi
V03Vjwiq1Rew2AdmxC7PgljtlaC5MJJRQOEdt+ER7ezGaU7xMg1rPjQSQX9qI7hv
keoDUllV/ufA2kSMPSnj56A4prOUmk+eBByIlZ0iuP0y21NlqBn6S7+QSsQILfsv
Iheoq/V1/RL5XtC65et7o6kL5cm3xuwU1Pxuxi/EZ0vvfjLHC9omjgOAVt1Le9g9
aSF1r0ueCVo/+wEt7p21GqRb8wmfX+Z74t5VW0xD4gSqO4yM2UdeFDzPEHpExutJ
lA+P9UfbCD9C68NxJXc6lwELjzeFnhxwy5Y5/aPpluwFwcmX1j8XgfVqXlYq7Nob
213JrkvW8PcbbrOU2vio1RXUGtbkwQRVsZCYA7SMVvazP/G0Nipm2yaywhHMHds/
2g8gonSS+UtUDSUwjIrS
=4gdn
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
