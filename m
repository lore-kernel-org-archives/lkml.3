Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaJJSD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:03:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60566 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaJJSDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:03:55 -0400
Date: Fri, 10 Oct 2014 13:02:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Johan Hovold <johan@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/12] rtc: omap: silence bogus power-up reset message at
 probe
Message-ID: <20141010180256.GU31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-8-git-send-email-johan@kernel.org>
 <20141010180054.GS31348@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O2g7+miYGsIKoR9l"
Content-Disposition: inline
In-Reply-To: <20141010180054.GS31348@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--O2g7+miYGsIKoR9l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2014 at 01:00:54PM -0500, Felipe Balbi wrote:
> On Thu, Oct 09, 2014 at 09:06:29PM +0200, Johan Hovold wrote:
> > Some legacy RTC IP revisions has a power-up reset flag in the status
> > register that later revisions lack.
> >=20
> > As this flag is always read back as set on later revisions (or is
> > overloaded with a different flag), make sure to only clear the flag and
> > print the info message on legacy platforms.
> >=20
> > Signed-off-by: Johan Hovold <johan@kernel.org>
>=20
> Reviewed-by: Felipe Balbi <balbi@ti.com>

oh, btw. This should be done for DT probes too.

--=20
balbi

--O2g7+miYGsIKoR9l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOB9QAAoJEIaOsuA1yqREEG8P/3fN9YIwts7YQ4E4i89g4Zow
JTz/GFvU0V638nsMfFx/rKacOFFbwgiSr6jyrwg985vt1dok/y2aeghQ/Ag+ON8U
X1e9sAXKWEYGSYj7AvMgQ4FQfVIw9KmtBycs+jer4derOqqNvSa6v++u+pVxtqrm
+BEf9rmSu06vMec0x6OpsKhQGQGJ60pTk6HWCG6KDzyEwg9eSEU4ZiopJJYXAtC5
3CxMayhGsJsElzJsBK/5WHl7VsVdUja7D8/OQCc46qAMF2z1bJwYhFMaVluXzTqj
XaxY7uaazY6em32lgxTQvgJUdBPXSxHgwHN7uil28Ou0bZLd9SOfOlNSUJrVCAeW
qLG1iCUTzf0CI9QJQZyL5ULCuYreSYGlAlGn85h/bsd2nvFiyJe1opEKAiXJouuE
Z3ixkPJK6g31973dRoaMV4+0DmKOzBZkCaIaCuXh9gw3EvTUMPMNwLUnlw3beqU1
qLtXcLn4xEGgL4101A6NtjKEiZj02hLA1/DlcsJTkkf/WW1wjCV+MPi2ru+MXGMz
+KCE/r+pixfhyAG9Uy1BA4xOWGNe86+cDivwxe/l5sJWkk5Bq9A8vBoRozdrQcUQ
xpElF2132+JUBoNg5cvMyrlCQaoVR4zDfcaKUacYaiqiEKP+W4tZeUP7doL4YTDB
RHvDS5WAmbMhikMM9hzX
=5DRq
-----END PGP SIGNATURE-----

--O2g7+miYGsIKoR9l--
