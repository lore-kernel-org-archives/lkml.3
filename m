Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab3FQKUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:20:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48618 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab3FQKUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:20:03 -0400
Date: Mon, 17 Jun 2013 11:20:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        sachin.kamat@linaro.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130617102000.GB1403@sirena.org.uk>
References: <1370864113-17895-13-git-send-email-tushar.behera@linaro.org>
 <1371460388-26177-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oQzL12nKbmSHS3MD"
Content-Disposition: inline
In-Reply-To: <1371460388-26177-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 12/15] ASoC: spear: Convert to use
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oQzL12nKbmSHS3MD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 17, 2013 at 02:43:08PM +0530, Tushar Behera wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().

This doesn't apply against current code, please check and resend.

--oQzL12nKbmSHS3MD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRvuLMAAoJELSic+t+oim9ZFYP/2mGzQNaaKGMOF/1zuJpYCU3
zTjmm1XJrTwz4W4PHHa7G0n6o9R2sjkj8QQbLsTZteXlE5BxKEt9kVJobcS9aTib
SP0QtGXFeDsxwTNymCvMmHdCboU4yv6n3Rln6927WC0twwg2ZKYRipTq1Tqe2ago
+wHaD0bOlTJx1x/m4l83aVpVVgONNOnX2cWiEZd0FNZ+hWPeVwSheQQM7XSAbsmK
UCZWfB7x1dydAuR5zUENG+jIjr13teAO0hS1HjxfzRNJnUD241soPfIYzHU2JhiL
M67+m42mKzEsHt9/o7ekwleW2lg/LIcTiGaTAL5qtnywxMOOYMgmu9fVtO8wf9qy
I6iWP+bqHkgwVl+C70Su7DcXSdO8G/tt25XjPyJJKBu/+NvHwRuz8Iahjy+lHE/i
X9xCkRuEzQY58FNkLAUrjD1bH2HPHqTEa5GUR3Q1Pc/Wt75hycqef4wRrAF7M/Fe
8bKee3A+EoDbSbX2Sfe0TLcvDgjq1TPrXmkjJsvd0wPXXEsMMENZhblShLBOyGLS
TnzVP1iLGi8ZTahhPO2EZiM2jmP+N+kXYx2ZLPkhPJUKswdABv7CXuqdR9ayBYss
czSljb+4F0XFocYT2oAxYN9Ce8qV875k+9mBtydRvSwi7/MBGZjqcgHXCEVenIQd
tPQnofRjfXv5W27KRqVn
=8kn7
-----END PGP SIGNATURE-----

--oQzL12nKbmSHS3MD--
