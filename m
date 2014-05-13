Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958AbaEMPFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:05:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52334 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759834AbaEMPFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:05:42 -0400
Date: Tue, 13 May 2014 10:05:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liping.zhou@intel.com>, <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
Message-ID: <20140513150534.GF1151@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140507215344.GH19925@intel.com>
 <20140514014551.GA16153@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SxgehGEc6vB0cZwN"
Content-Disposition: inline
In-Reply-To: <20140514014551.GA16153@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SxgehGEc6vB0cZwN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 13, 2014 at 09:45:51PM -0400, Zhuang Jin Can wrote:
> Hi Balbi,
>=20
> Do you have any comment for this patch?

do you have an easy test-case which I can use to validate on my end ?

--=20
balbi

--SxgehGEc6vB0cZwN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcjS+AAoJEIaOsuA1yqREnnEP/2CNYg3HvK8p/qXKYsLFC2fM
7TE/OB/YH9zkawnOk4LZJfJJX6nomH+I23iGFmPnLTDE2r5lIPkXLZWdOFyVS/hC
E06R6wO2IU+Z0i3OTFP4clCl7RDmzee4RdbwBxcssu5l/61CrWJAJlVpopYP91pt
lRfoES+H3FD/IKFiKSqLMDnxRJSgjwtsEunmK/RJ38Ts+SuyvnXJ6t9CITOh9gjR
NmbS5CT/l/dc5OKhwJy0CBExKPrudwh3Ri/kPmER+8x2oblz8yjFcIPPiAucQhoV
H9OXwRfVYQy96NwYhawScZcFMRLrYjMtvZNgJQ6Ja3PILTC/Y6/RE3hb81UINp3I
6kH0uJ/CWH9PV0aNt/RB4DL3iMS36UsHBdIdf+ucSpfAJOXKCTuE5pKu1Cqz4XcF
Enb8siEHUWjDDU+nozoNme+pX27lwBiRprRAHcoZ1S5SbRlR/XBGVWQsULN1iJIl
xt/KzCCEu8fabf+QxkyyV0b2rTR/EMyFGJhCkvUv6uk9ADX0P3hVHkMz1V+jW9eD
nQmHrK8BFztC2/4iKK7jabyusd/F4u6Mo1XX5+h83kgT05ysa0KEx5kqYmxnAJ0b
d1lje2F+ak/mKTXyBbz3jNIijRUCjOwVWpiKJ7MQO7dMmEBHmHBGQyDboqlWpX3y
uWODlaUsbKkiTb9jhErM
=SQnj
-----END PGP SIGNATURE-----

--SxgehGEc6vB0cZwN--
