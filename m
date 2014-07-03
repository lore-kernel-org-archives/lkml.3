Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbaGCNGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:06:01 -0400
Received: from mail.kernel.org ([198.145.19.201]:57229 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbaGCNF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:05:59 -0400
Date: Thu, 3 Jul 2014 15:05:54 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH 1/4] power_supply: Add inlmt,iterm, min/max temp props
Message-ID: <20140703130554.GC19290@earth.universe>
References: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
 <1404122155-12369-2-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="w7PDEPdKQumQfZlR"
Content-Disposition: inline
In-Reply-To: <1404122155-12369-2-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jenny,

On Mon, Jun 30, 2014 at 03:25:52PM +0530, Jenny TC wrote:
> Add new power supply properties for input current, charge termination
> current, min and max temperature
>=20
> POWER_SUPPLY_PROP_TEMP_MIN - minimum operatable temperature
> POWER_SUPPLY_PROP_TEMP_MAX - maximum operatable temperature
>=20
> POWER_SUPPLY_PROP_INLMT - input current limit programmed by charger. Indi=
cates
> the input current for a charging source.
>=20
> POWER_SUPPLY_PROP_CHARGE_TERM_CUR - Charge termination current used to de=
tect
> the end of charge condition
>=20
> Signed-off-by: Jenny TC <jenny.tc@intel.com>

Please update the commit message according to the code. It still
uses POWER_SUPPLY_PROP_INLMT and POWER_SUPPLY_PROP_CHARGE_TERM_CUR
=66rom previous versions of this patchset.

Once that is fixed:

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--w7PDEPdKQumQfZlR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTtVUyAAoJENju1/PIO/qaOXAQAJ3+ao6lpQxgctpgNZZqAjNj
y0KQTqskK9uCWG71hCkQXxj6lxOwqgyj2mhaNuGaoH5ViU377QpM/YXmawTCcmjZ
J4l5B1mgW/cSXHyno+F12JyGeYGVcB6V9Tfj7L944AWCnnaW0kg1JSdAxZG7yC2C
0p9koBWbwKI+By7OtNOl+6yC9AEnq8NuLJYrBxw4w94Ddoaci5gVnDx/oIccH7bK
g9kM5w8SQPRkbgSEcpQwcuRuOjzMwEbpcuJGMnhGPdFJcYbvU2gg1yivqXzLiZlW
cp8TqsMNaB596xwpte3ttNDF+pJe7QCN55UjnGxR61X8RGjlXCKKSLvhLPlnL6cB
eBZoX6XSOEn+vN251WixNLQL47bUc7Txj3l8YNPO5MLGtkBzRf1eS7aovQLWA7K7
pRja8JGZha5DsEMlmlBej3UragDRbXlC3djC9mb0RfYCAAaKqYp5VbA95KbWnMpL
U/UXXEGBg9eNH/uNf1d/bBmRK8qZwhXN+reZlT3WTxSbAPlHv9l6o84+TmeLK5Sb
gvVyJF2u4dskEAvKvbvIFI0XfPjJXjPST+Hp12cMdrwXAXBRzLP2CVEnD6s9Hx72
7WgGytKgsOaDOpYmNUr6+MKtU6Hs/uJDLWnBXmDYqbL/4m1OzI2AEP9L5DLnQ2Yd
QsI+nUblv+1VQCpZH6Gk
=f3zA
-----END PGP SIGNATURE-----

--w7PDEPdKQumQfZlR--
