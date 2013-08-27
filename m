Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3H0UDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:03:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41821 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab3H0UDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:03:47 -0400
Date: Tue, 27 Aug 2013 15:03:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Graham Williams <gwilli@broadcom.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>
Subject: Re: [PATCH] usb: acm gadget: Null termintate strings table
Message-ID: <20130827200317.GH3005@radagast>
Reply-To: <balbi@ti.com>
References: <063828A851006E448B735F1021E028962ACE5A03@SJEXCHMB09.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x2Q4gGavnTuI5DS6"
Content-Disposition: inline
In-Reply-To: <063828A851006E448B735F1021E028962ACE5A03@SJEXCHMB09.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--x2Q4gGavnTuI5DS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 22, 2013 at 07:10:04PM +0000, Graham Williams wrote:
> The gadget strings table should be null terminated.
> usb_gadget_get_string() loops through the table
> expecting a null at the end of the list.
>=20
> Signed-off-by: Graham <gwilli@broadcom.com>

complains about being a malformed patch.

--=20
balbi

--x2Q4gGavnTuI5DS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHQYFAAoJEIaOsuA1yqREiTkP/1xSqVmk5qXge7lIMAQlhhCB
22QH7LKsscJ4PdPZuKqDqmuhaz8Qlj0zYpDM1+azV9UJgkX1FfUTzJoEBD7fgP2R
UcJQpFIC7XL0bu2cJWWcvu6wrhx+gqTUaGsbDMuXxEtiyq+bn0XIXw9RqRlOc2N/
0GlwRoprtEsF2JEO3Et9pxyGGBUXJMeshwQn4SBIW8LV1Q0VijbAGA1zwTOtK8Lw
RaGEZ4toIg1ULlDW08mISg2IDYRg6K5vhDcjTi3cqff/xY/gbMX+R0PIZa75gD0X
RMoaxWcRhB/LHwAn0qabN+p8IWrqZB+McFFWTMPpvhOPHWL5Y6n5AVyb+DOi2yo8
afU8f9d1cPJs3g962skzhkibI492uiIdyeg/Mgd4lUrMydSnG+5zJ13UfaW2JyqM
n4/S/7n4Wt5t+UMnm2qHq9yYcnRp7ePTtgdd2P4X+9Ay6qTmdW7uVG6NhejeFn26
FUbkMrtq+9GkrRadpXdHFVFwNGRV6rN91fRLPDLD3pphUHoytXUMZtPqZSMqKWV0
F5hJxlbAk5Y7yDbfa0keRIpk1/wBdJVFtkKFS+MGMi7J3rAzbnUBqeP4HkxDKNyt
GQNYiMYuLgU9bAwxy57QGcHQsy0CVTaINbRGAj+M8iOU7jOmMl788Xi0o0X3Pg0T
hJR/NaafFHJxx1Qe+9Rk
=XNeL
-----END PGP SIGNATURE-----

--x2Q4gGavnTuI5DS6--
