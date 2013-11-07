Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3KGUG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:06:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56808 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3KGUGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:06:17 -0500
Date: Thu, 7 Nov 2013 11:36:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20131107113611.GV2493@sirena.org.uk>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
 <1383732985-18928-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L7QcuKEPlEDqpLxW"
Content-Disposition: inline
In-Reply-To: <1383732985-18928-9-git-send-email-lee.jones@linaro.org>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.186.138.96
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/13] ASoC: generic-dmaengine-pcm: Clear slave_config
 memory
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L7QcuKEPlEDqpLxW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 06, 2013 at 10:16:20AM +0000, Lee Jones wrote:
> We currently assume that the DMA Slave Config will be fully populated
> by the platform, however some DMA Engines make decisions based on zero
> (default) flags such as DMA_SLAVE_BUSWIDTH_UNDEFINED and as this is a
> static declaration we need to memset it to clear the data area.

Applied, thanks - given how near we are to the merge window the whole
series isn't going to go in for v3.13 but this ought to do so.

--L7QcuKEPlEDqpLxW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSe3soAAoJELSic+t+oim9oMoP/jiczpygUVwN4NKHW6y4HsEs
9Zlb0PM6MhSJ3tME3rrqeqVgXx3W3YEEh5QGzzaBO0JxBIobwBjNuWrZPRW5T/qO
jAj2R+c0Q+Fy5FXuFebsa+9DaQA2gI4Zh/6UXVWhPmKqNWJirViId+HKX7XtQUAg
/lv1c+myIju/yRa72ftQhTN4WlfVadr12VqjbNZMUtF22opQm68Jl1+Nuiv4I665
xBF4ekFCQvG80p4jo6OZeiR0rkuOYE9JWXBWLrTLCHuLtVxhYUQ+8EkUdd82hzy1
kLS7fGfluQ749xUuQev/vvvnKUkYL/4xeyDrR2JFOUOE9I0Z7fclaLXH+Tnsc72M
UEKy7d3lQGepxP4/ufQ92k4gTdFN+HObp0PZYjwxTC3FS6FOYlBznYkmVLbF5PYz
Qoc1qNfyLxoh+eSS4QpcT9EA9/NbisIS7MuGx1WuV8NcWrEy4LzWCIrWCGz8Cnzm
rYtRfogWPuYWErAKR9OLbWNWgNmr82HHjXx7X6aQ+ZUmQhzni5zjDG1e97StgmnX
R34Yz4/0GHR4pls0YrpxLpH1bJKBFZ66ppWfU9YwqabRhHfqHILvCGfk5+iVDgZY
dTYXf1QxTGZQnBeQ8nS9e1QgyYU568U3ZGxbN0Rr+nX1QnaZGnFzqiNstQZgXOpc
XwYo8Pnbi7K8LDv+Qfjr
=Y9mU
-----END PGP SIGNATURE-----

--L7QcuKEPlEDqpLxW--
