Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab3FMStp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:49:45 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:43124 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886Ab3FMStn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:49:43 -0400
Date: Thu, 13 Jun 2013 20:49:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mayuresh Kulkarni <mkulkarni@nvidia.com>
Cc: tbergstrom@nvidia.com, amerilainen@nvidia.com,
        thierry.reding@avionic-design.de, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] gpu: host1x: add runtime pm support for dc
Message-ID: <20130613184938.GE32574@mithrandir>
References: <1371117218-2326-1-git-send-email-mkulkarni@nvidia.com>
 <1371117218-2326-4-git-send-email-mkulkarni@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WBsA/oQW3eTA3LlM"
Content-Disposition: inline
In-Reply-To: <1371117218-2326-4-git-send-email-mkulkarni@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WBsA/oQW3eTA3LlM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2013 at 03:23:37PM +0530, Mayuresh Kulkarni wrote:
[...]
> diff --git a/drivers/gpu/host1x/drm/dc.c b/drivers/gpu/host1x/drm/dc.c
[...]
> @@ -1128,9 +1129,7 @@ static int tegra_dc_probe(struct platform_device *p=
dev)
>  		return PTR_ERR(dc->clk);
>  	}
> =20
> -	err =3D clk_prepare_enable(dc->clk);
> -	if (err < 0)
> -		return err;
> +	platform_set_drvdata(pdev, dc);

Why do you move the call to platform_set_drvdata() up here?

Thierry

--WBsA/oQW3eTA3LlM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuhRCAAoJEN0jrNd/PrOhyjQQALJXA7pC8gN5raC6QgJ22FfM
zy8Sursr8bwcCFePa0vuZG6dGorfBqzWteEEm1dC6Je9Y4DdlmlH/GaY2Z2gVtpW
q5qnZkuokU/QMPdz1pWURjvC+30y/oLcwgh37cauixZkcfcP+K025o4zrd70jIby
s5BuJdaZrEe2AoBTXCxhuAlfvcKNj6PKCurknKtR7+5gNUwvyjRB+tWnpVyMnBYA
glYQBhZOnwcUyO1PwWCCdre3Y/oVpm0cXR5Fj1MTXQXXh9owavIDVcUHLKGwevkz
WAPzkOoEW8yYCytROqHPGoCyEApglpu4iAF4LkcvhrT4WurC1Fc/dJbdYGf9jlFf
FS4RBszLOjQVhwV5YGydGuX5QmrDDVCGZRFNxi/Ek7IhACb86ol88SkhbmHSGmKJ
oNws9R0XUNb07EfaxjPTRSIUKunIvqcRr0e3gnFzs443c76y4L+5ry74LViQXnz9
57i9fJ8dWt+OpZ4l+WcLt5g2rzYiWLUsND0zEqKwo/OQlfPOpaKlbNfujruaRHtO
dQ+Z2jxVY383MHHki2hbFSYNYmrET5qE7FR4UCvlhijfSPYqznxJDRXNtj0O0EqH
+xW1CELOxlR31soYXfMnyGyNsiajfBB2eolkmR2OFo8dh2mjAk2jEkR36sBmX1Qo
VfloWSPNB5riGqrq54ok
=Bicr
-----END PGP SIGNATURE-----

--WBsA/oQW3eTA3LlM--
