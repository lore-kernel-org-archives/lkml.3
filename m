Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab3BKPuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:50:08 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58609 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551Ab3BKPuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:50:06 -0500
Date: Mon, 11 Feb 2013 17:49:47 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <b-cousson@ti.com>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 1/2] ARM: OMAP2+: Allow clock alias provision from device
 tree
Message-ID: <20130211154947.GA18684@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360597464-8491-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <1360597464-8491-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 11, 2013 at 05:44:23PM +0200, Roger Quadros wrote:
> @@ -36,12 +39,76 @@ static struct of_device_id omap_dt_match_table[] __in=
itdata =3D {
>  	{ }
>  };
> =20
> +static int __init omap_create_clk_alias(struct device_node *np)

if the rest of the folks agree with the aproach, looks like most of this
can be made a bit more generic ;-)


--=20
balbi

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRGRMbAAoJEIaOsuA1yqRE1mUP/10O7v8YdQtKVvLLTfP3jy3s
bvhYQJKxCsztJQ9LeJB1ODDjBCcXejuidUSrABL5tlWumjXT40bvbR9zxe6aCjiX
FOUYazuSQoFtFBY4QKRyQtikgdIS4NBNbHmvB9JupQmRS9jvPt2g+YoUpm9YUQlL
OIiTRLhNMBSK7k9gCfj0x8eHK+w7GtAhKWhomA/+d+4yGu6Fk4nfmMlJbnELdhho
4AnP6AG6+BnG73pTIlpJMiUg7vPSiyLOEcfPa/KAU1mTMCyYY488hFsN2Zt9quc3
hT0+1JZCvpATEVDC5i3colqqYSSV2D9D7aFtT7mi9jHuFgzCMENN9ocUuQ42E2v+
pD452xSPQDf6LnterU6ZLuNZfJrUFX94K3Gf5Fs2YR1tf5Q8/zAFmN1pJ+WKr2Kj
Vi935mnZC+9WS0m/cKVjiV4fDQNaYMtpqLpjXxSzCdJTlCsyEEkwWpNzbZUOumfZ
JX7GvxP0OVc9LHyOBsPFo3gpkkqQqwtiEBoEGaBuu33Pwf2iWaciAx4oc7ie7zN/
HS4ngzB57QXgEIDggnWe0VsSABow233+cPy8i2Yi9p3FHf5o1JqwK4WCofGEV7ZV
FFmsrB9mTf0iiQ1ynYB0haPO1bsb9sX3gVNatDEVb9i2HRRelXJsR2rEHAttP238
CJaMMBPRYLUznB+5i8qA
=6+e6
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
