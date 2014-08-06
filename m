Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaHFR4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:56:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50093 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbaHFR4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:56:47 -0400
Date: Wed, 6 Aug 2014 18:56:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Krause <xerofoiffy@gmail.com>
Cc: "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Message-ID: <20140806175631.GI17528@sirena.org.uk>
References: <1407344128-9754-1-git-send-email-xerofoiffy@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vdyEe3aauNFvjM8k"
Content-Disposition: inline
In-Reply-To: <1407344128-9754-1-git-send-email-xerofoiffy@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Fix warning about redefinition
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vdyEe3aauNFvjM8k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 06, 2014 at 12:55:28PM -0400, Nick Krause wrote:

> +#ifdef WRITE
> +#undef WRITE
> +#endif
> +#ifdef READ
> +#undef READ
> +#endif
>  #define WRITE 0
>  #define READ  1

Please think about what the effect of doing this is and look at how
other similar problems have been addressed - the goal isn't to shut up
the warning, it's to fix the problem the compiler is trying to tell you
about.

--vdyEe3aauNFvjM8k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4mxMAAoJELSic+t+oim9rBsP/iBlgIW3zoVGmL3CCtGwbDTS
MkG48W1fdTCB0bhAAe3Yg6G36Oe6Gv4tvMIB/IJNdtFNr2lutX3BGdxucAn6w3YR
vPkpy0QysdSzdFzy1vunrSFuAQpUswPL081olwbyD/iFmOsHSL+Mbbqu8p2T58Qf
W3Jkx+vvVXnZNyEUravKn9cjuymLcb9zNWBTfiVAuKiMFDUdC+JDJwyjSOFjRMfk
sUtTWuj0T5YUWHcul3KR8rMDWxSzFdh2Exduo7f029XflkCVZ4j9x/WjDNdhZus/
14ecQhl4NsiaalEzEDpVkVpBHoiNVCtHW7yKeFopT6LKbFGmBpPUlnp0bkhjzXYZ
AIiDO1KDO4dAw6to+hbP+XR7p8UtDl4eiXoak/iAEc+p+q0KiuOm9h3mK3HDBxU/
eEdAtHcCENbJYFi9BddSe+SjbxX262x5Zd7M1kvThRWXnUqHPK1jOSVpkDR9MRq/
/HJfyjn902oKtrdljYREnUrkJwUmv1ifdIElq92M2ggjAGz6LBsBEGLm3SRy+AJD
5b3NYwk1LmPky1YDEMxecAv9UTVi9t6TfC1p15cBstNLH5RfukbJKN8P/ETxpfS+
EZW3kg4fF+cVljB4AiLNKas6mPHEzkSumWNBh5VisDtvFRNUm08kvZCGT5P5h6bj
z/bMjhCPRon3pcwhIIU0
=9TI1
-----END PGP SIGNATURE-----

--vdyEe3aauNFvjM8k--
