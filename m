Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984AbaDVPRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:17:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36709 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbaDVPRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:17:09 -0400
Date: Tue, 22 Apr 2014 10:14:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v6 03/19] usb: phy: msm: Move global regulators variables
 to driver state
Message-ID: <20140422151444.GK5524@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
 <1398158438-21579-4-git-send-email-iivanov@mm-sol.com>
 <20140422145745.GJ5524@saruman.home>
 <1398179539.4724.168.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="00hq2S6J2Jlg6EbK"
Content-Disposition: inline
In-Reply-To: <1398179539.4724.168.camel@iivanov-dev>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00hq2S6J2Jlg6EbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 06:12:19PM +0300, Ivan T. Ivanov wrote:
> On Tue, 2014-04-22 at 09:57 -0500, Felipe Balbi wrote:
> > On Tue, Apr 22, 2014 at 12:20:22PM +0300, Ivan T. Ivanov wrote:
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >=20
> > #define ENOLOG		ENOCOMMIT
> >=20
> > return -ENOLOG;
> >=20
>=20
> #if SIMPLE_CHANGE
> #define ENOLOG		0
> #endif
>=20
> Will fix it :-)

#undef ENOLOG
#define THAT_DOESNT_REALLY_WORK_FOR_ME

hehehe :-) Thanks for updating ;-)

--=20
balbi

--00hq2S6J2Jlg6EbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVodkAAoJEIaOsuA1yqREo58P/0uO4R/ISGSF01pfryX5KQhY
xHyvR9yayONmH7aV1wckryD+0I77B9F00bXf2pmtK1ftPD6kgN1kGtmXDnRgZ0U0
jZrq4RuqfpR5AsfHY85UGtLuSVSXOTW8pZAoyklJGDr8AMQNIU3DQTpIKRUP08B+
2uPo2w0qRImVP9H1V9eVdZrjNhnQqnAEte3NLxG28rURal5qZg0HIWCFxvj+GQVY
MDLKnHzk1VStYKUgMUjOjnDjPAy8eeMNsqdgsZ0YR8qZ28GuQMFv2yn3SPkbMmDx
f/mpInMDv9Dc+EudPHaeq9AUsqVK1DFJ5/qcLYY8zHYwepl8RMJJ/xOLZIL5n6Qb
J1fn/MYDfkp9PoveRCd/LbmBsGbrmuixYUzEHtarTyJnCABT4QmoYjx49fjieeCn
yI2MuB/GOaOzGdfp86N8hne5r64ZO/Fk0eQJPW7ycAufvdVksfby8sKzeVF9eR4N
GboDY8xHNnLZGdZ13DZrDJxosIlx1EcdEjD7AauSYPRPfM7BJg+wA1461aYmQaoK
rhEuymP8EN60inSBkoEcfqYiUPk4JnDAtJnhfAIeGIpESu+e27OYYhrmQcCgNHCJ
PQABkqIsiMnLInKLWhDHF/Dadm59DQLwERQt7z8ZjrpFimzSuQIQzgWhJY+5SV8l
kmr2hOKihmQAv772dxi3
=TFbP
-----END PGP SIGNATURE-----

--00hq2S6J2Jlg6EbK--
