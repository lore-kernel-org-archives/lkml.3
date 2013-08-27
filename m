Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3H0TWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:22:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60940 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3H0TWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:22:14 -0400
Date: Tue, 27 Aug 2013 14:20:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>, <balbi@ti.com>,
        <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <stern@rowland.harvard.edu>,
        <broonie@kernel.org>, <tomasz.figa@gmail.com>, <arnd@arndb.de>,
        <grant.likely@linaro.org>, <tony@atomide.com>, <swarren@nvidia.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux@arm.linux.org.uk>
Subject: Re: [PATCH v11 0/8] PHY framework
Message-ID: <20130827192059.GZ3005@radagast>
Reply-To: <balbi@ti.com>
References: <1377063973-22044-1-git-send-email-kishon@ti.com>
 <521B0E79.6060506@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kqOsKy60S4p104jH"
Content-Disposition: inline
In-Reply-To: <521B0E79.6060506@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kqOsKy60S4p104jH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 26, 2013 at 01:44:49PM +0530, Kishon Vijay Abraham I wrote:
> On Wednesday 21 August 2013 11:16 AM, Kishon Vijay Abraham I wrote:
> > Added a generic PHY framework that provides a set of APIs for the PHY d=
rivers
> > to create/destroy a PHY and APIs for the PHY users to obtain a referenc=
e to
> > the PHY with or without using phandle.
> >=20
> > This framework will be of use only to devices that uses external PHY (P=
HY
> > functionality is not embedded within the controller).
> >=20
> > The intention of creating this framework is to bring the phy drivers sp=
read
> > all over the Linux kernel to drivers/phy to increase code re-use and to
> > increase code maintainability.
> >=20
> > Comments to make PHY as bus wasn't done because PHY devices can be part=
 of
> > other bus and making a same device attached to multiple bus leads to bad
> > design.
> >=20
> > If the PHY driver has to send notification on connect/disconnect, the P=
HY
> > driver should make use of the extcon framework. Using this susbsystem
> > to use extcon framwork will have to be analysed.
> >=20
> > You can find this patch series @
> > git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git test=
ing
>=20
> Looks like there are not further comments on this series. Can you take th=
is in
> your misc tree?

Do you want me to queue these for you ? There are quite a few users for
this framework already and I know of at least 2 others which will show
up for v3.13.

Let me know.

cheers

--=20
balbi

--kqOsKy60S4p104jH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHPwbAAoJEIaOsuA1yqRE2nsQALFK6rMKqgAruQXU+gcAWuJg
UjjW+Xp+SkOhvWawDZw1DAWBVwzDb0sBACYnCKxgsBKjHxXpTXTc3FeMl9zUxDa6
8ViDWK4HpkkesIdI2lGbEPXL0sgSzBwmpPXAv2ctZFuKBEzPuNLxqcHNLKoxYeF9
RdGbESxggPmmVL25iwOu187DvEcX9H+PZ2HzcJNjRjHX8uLOCDLZo6zGs61rqFpB
vGMWgY+eP5NF2o4taf4JsSYQCT8F8Vda7cn5dNEekk0h7pIzHbCFbgqvuPax+zT2
EjK1mRAj9mPT8qQIBR4F3ubiPXBBNd2pHHvXeC0WmEfxyAl74bZcOvRhER97jPFd
CJFAy2pJRlEXOfHFHKQ7a3BbpY/fjacRJgbsB04JoPwr43Huin/w82+pO2LYnYVb
LAA7avWE/4fGqUqlchiCcpSaC4rxTtF613t9GiVsim7oVE/BIIKqqbTdqSOGey2k
BcKtFfhN62UZia7EGtdIttbdnBYffAzO5Mh4bTmF3APu1NvkGv36vzUcPukh1rB/
bvxYPriPwtJEx4sQUmrta9LIvK5/7ogsHpB2FqhSywjc7H94PXwJGeCWTX5ZYrk5
KNidKS5P1+F8HVA2Oa3E6fGEC9dMWi08YYUhykTw4nvwn7mSV0c2zERxHE06J9SN
4SNq+kshoP9LPk9+IXfg
=n6Sq
-----END PGP SIGNATURE-----

--kqOsKy60S4p104jH--
