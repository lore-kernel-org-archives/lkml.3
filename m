Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3FYPSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:18:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43121 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab3FYPSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:18:48 -0400
Date: Tue, 25 Jun 2013 18:17:53 +0300
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
Subject: Re: [PATCH v8 1/8] drivers: phy: add generic PHY framework
Message-ID: <20130625151753.GF21334@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372139926-3719-1-git-send-email-kishon@ti.com>
 <1372139926-3719-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nYySOmuH/HDX6pKp"
Content-Disposition: inline
In-Reply-To: <1372139926-3719-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nYySOmuH/HDX6pKp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 25, 2013 at 11:28:39AM +0530, Kishon Vijay Abraham I wrote:
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> new file mode 100644
> index 0000000..7abf573
> --- /dev/null
> +++ b/include/linux/phy/phy.h

on this header, how about adding phy_set_drvdata() and phy_get_drvdata()
helpers ?

cheers

--=20
balbi

--nYySOmuH/HDX6pKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRybShAAoJEIaOsuA1yqRE/hQQAJI0nMYwOYxaHQduvK9XCWrY
8i60KnCwLWvbpUeRucJ/ucNzAKtoSb//lnnUffGlZGi92QSr8hYuKFCu3P0k2KgX
N1gkZyaG4g6bIaBgse9zVphYRb0AWoSQbsOG621sSKM1beE9AaEV3NY9Nu2lILdA
zYfx/LoNU+PQ9HyTHjAHWgONZQjm4+z2ABhsw0EpM42/74N8hkmSi1tZELg9oN3u
VaZ0xJjeN6zj30y7+gEcp0vb9e7e3KUhMbt/WTL17VspjHucKlrWxD7/9k9spL/w
kuCKuRu3iaTZcD6oi98RlvhNCEj3HS9Jg8ASdn8BfmGInZj71bedSwMONyt/Hm2j
FVHQnxMC40ir+BkidFnJvwjbGAQc0d4S+108HfWa9uEvAQarZtr9Ul0puHDeqocI
Mlk3IZDhDXlgMLhvRn5zzqRmopxrp14H6tHhFcStvT2SatUb0RxreSXO7VJrStoP
O1N6kVB+9DGXn1xEVU8r7jSQPZzT0a2MLa8satfqV34CSKsu10aQQk2VRyRCEJcK
QCc5J3zqqPgwYFy+rKDDTkU53NjERCtV8MYtmwhtXPqyRIA5WsQQq26zdrF7Zp88
uaBR0ZUSM3cWd47rQmBnRmnEQFD7EFCeCL9Fe9X2ZBRNsS+b9V+Z5syNfr8IclJ8
G51h2hhdM300HPVYTlM0
=iDEU
-----END PGP SIGNATURE-----

--nYySOmuH/HDX6pKp--
