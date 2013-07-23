Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab3GWEWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 00:22:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40628 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512Ab3GWEWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 00:22:03 -0400
Message-ID: <1374553313.16248.68.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 10/18] ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to
 skip DSDT scan
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Tue, 23 Jul 2013 05:21:53 +0100
In-Reply-To: <87txjm609i.fsf@canonical.com>
References: <20130719021048.965829361@linuxfoundation.org>
	 <20130719021049.669930750@linuxfoundation.org>
	 <87txjm609i.fsf@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BzuZoSdZbY3UbE0npkf+"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BzuZoSdZbY3UbE0npkf+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-07-22 at 17:13 +0100, Luis Henriques wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>=20
> > 3.0-stable review patch.  If anyone has any objections, please let me k=
now.
>=20
> Sorry for the late review, but this patch is actually tagged for
> stable kernels >=3D 3.9 ("Cc: 3.9+ <stable@vger.kernel.org>").  But it
> is probably harmless and not worth the trouble of reverting them from
> 3.0 and 3.4.

I don't think it does any good without the preceding fix (commit
2fa97feb4406c546b52e35b6b6c50cb8f63425d2) which unfortunately requires
3.9.  I don't know whether it will make things any worse.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-BzuZoSdZbY3UbE0npkf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUe4E4ee/yOyVhhEJAQo1VQ//bkT3mKbO+zra3BoSacS/lYOtUh4sAzuB
rAL83z+mEgrZcCBjQDaDIdtwe83RGXXcX7fyYwU9yvkLaanTfk3ns8jyTOuwOeM/
3Etw4IV/B/JXB9ypWF0gSjGxaqpGGbKvsXJP3tpoHl/6KegCkYeS/KaZgedgUuQ7
eyXjukQ9QH0IGlfFPiA9o3nVZIrHbTf8UmRBW53xul1veOTkkAkJadlZI0mwrkY6
sGHTXRkChnwFNcl2FPazI/xUVtHFAtZukECBgppJyHQo6kmTFSNmZxpjVYSEkE/I
LYTG89gvj+cSR5ngKlDqckdvDKAcsLb9O0UGOasTpShYB4RVB6+Xx4/hbTO0KRdm
GqKsgj9TL3zcFIJGGsf1sE7VY0rBg/QMj9+TTwCGE26RK2Y0qGpjefTfld5Zb0f5
C9zhf4tjYvF6dhc/tB8dEcFb/6Fk4SkNJqIpUXgxMb3dnIshOaMRjwQAxH5AFsp5
ESQ3X8THeEE8nJIJVY/SUYdIt6gpnXwUmpy+zmEgKi68CyClqcyf/V1MRaWlUI3R
I06RK/gN6NiVBze9r1lfnImNe2aUIGzuoBo38MAbDI3peHEv/phbhhZEwUtVtPOV
1Pe0SU/uHPEbix+j4LDqLssyxiXP1nuI0gwzCw0QZexD6Fsh/gvRAaW0pDM+Qgvg
sJXsw9PB288=
=pqIn
-----END PGP SIGNATURE-----

--=-BzuZoSdZbY3UbE0npkf+--
