Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967873Ab3HINhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:37:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58785 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967795Ab3HINhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:37:36 -0400
Date: Fri, 9 Aug 2013 16:37:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Tuomas Tynkkynen <ttynkkynen@nvidia.com>, "balbi@ti.com" <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 6/6] usb: host: tegra: Tegra30 support
Message-ID: <20130809133722.GK12041@radagast>
Reply-To: <balbi@ti.com>
References: <1375812518-3847-1-git-send-email-ttynkkynen@nvidia.com>
 <1375812518-3847-7-git-send-email-ttynkkynen@nvidia.com>
 <520141F2.4060907@cogentembedded.com>
 <52014B89.9040106@nvidia.com>
 <52014E0F.10404@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="08ATZu8fEq0x2T3M"
Content-Disposition: inline
In-Reply-To: <52014E0F.10404@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--08ATZu8fEq0x2T3M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 06, 2013 at 11:27:11PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 08/06/2013 11:16 PM, Tuomas Tynkkynen wrote:
>=20
> >[...]
>=20
> >>>+	match =3D of_match_device(tegra_ehci_of_match, &pdev->dev);
> >>>+	if (!match) {
> >>>+		dev_err(&pdev->dev, "Error: No device match found\n");
> >>>+		return -ENODEV;
> >>>+	}
> >>>+	soc_config =3D (struct tegra_ehci_soc_config *)match->data;
>=20
> >>     Aren't casts from 'const void *' automatic?
>=20
> >>WBR, Sergei
>=20
> >Indeed they are, but those explicit casts seem to be used in many places=
 in the kernel.
>=20
>    I suspect people just don't know C well enough. They are also
> being gradually removed.

yeah, please resend with the cast removed. Also, put Tested-by, Acked-by
and Reviewed-by in place.

--=20
balbi

--08ATZu8fEq0x2T3M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSBPCSAAoJEIaOsuA1yqREa0sQAIj05z3tSDaYYvkrmZ1CAX/N
ADfSDE9jEmtTJV3UlqflQY8HwnrfzgxkJn7ovLsMrde83uMN2VZMGcGYjQ0+WVt+
RTeXtAcsGQdUTcI66ZuKKLy2Ns+I+BlDe78WsARDukc0dT/ZmoxwdcXWJNLCe2PD
RNVWkH4kpYVx5pZ7j8DCGBjg1GBcX6amB6hLcFejuoN5o+IeGb8UFP0pgdgF+Eni
egLJP3fiigby8Vz1qw2C7xM/stRfQHAFX8hBD1h3+93APyhIJm5C4kztz1gC4RuC
2VDJpsul4ZuR2it93/AMROEHR6WeikaOVfC1JxEacpNgZIMUT/TOX9dkhlOUwZKz
hpJ3DkkiPensILwVwr6pU+2aNbNrNtcPUWFUOiuSosE0nMjeRe7mTtASuLkRSb4C
XLGBh4YuiwEswzBMDu2yjtlQe+1zhOGBJiiua5Ja1nETl4b2WTVp1pKKzv+A65YK
W0jQcUIWN7pyi8LsS9wkRkSPYIN/pgERhCXsHuT13WCAphxrm8tqsiFc7dXvSS7y
EsJgDBRxex1FZj87eX4Iu0WzqOdwgV7zajesgMAN9STKwn6WHrwmQuRJ94Fc4zNc
yjVUEJf/o2mG68pVDPucORNEB7LffZMv3vQHq/84Rc5XjvXZP7JquUDGITr1t5ie
pgBYg36RSy/3Wzt5XRU8
=aM5V
-----END PGP SIGNATURE-----

--08ATZu8fEq0x2T3M--
