Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab3KRMgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 07:36:03 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36452 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3KRMf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 07:35:57 -0500
Date: Mon, 18 Nov 2013 12:35:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Levente Kurusa <ilevex.linux@gmail.com>,
        Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>,
        "levex@linux.com" <levex@linux.com>
Message-ID: <20131118123552.GA14306@sirena.org.uk>
References: <C3050A4DBA34F345975765E43127F10F254A8BE3@szxeml512-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F254A8BE3@szxeml512-mbs.china.huawei.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 178.107.40.197
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Fix 'ret' would return an uninitialized value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 18, 2013 at 12:29:02PM +0000, Caizhiyong wrote:

> This patch give a warning when calling regmap_register_patch with
> parameter num_regs <= 0.

Applied, thanks.

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSigmfAAoJELSic+t+oim96DUP/RGrb100CKsixg8CxiyFAv70
3Bi9BnTEA91zjMuUejzwm9G7VTNSFgYev9EuVmLMlA9zOw6C4VF3UIKIw6t0+EoN
HBAqAaBGtJ8/fvbSyVgiYr0hsymi9EbUr+KbxiYhoTyGFSEzve5F+i6IhFUipbXI
i4AFMCbXOJTOsOWTB78ql21r6TJptgdniDINrp8aL1g1Z3jYJ09QpDUCqkQl6x0L
23nQK3yfg5YueVHLZLa2z95HbF5V+8vuq1NbswQspPq1DW8egMTnmeKdxHyJX+t5
BGFqqjdUW27Rhzx9LjSkW8JlUOQ8nKEvkBj2Oj2jv/mQtEhfGzaDVaycNLDLooYw
RYAfZgU1Uiyk6RMH3HdKhN4go1zUVRRPUbE68gzxmr2CfleuOzR2GxIeP1Vlw5NI
P2hSIa6SZzgx0i6I9n8WNvMTXbvPGx+L9i5+0R86xCH0TTd8cgb+aACbQdQZhTUE
7Tcvi7PNC4mH+1FHEQ8ddyWTKZKJUcEU0//PIRChteQOuAow4CxuhMOrXUZsyZ3c
jQ1EwyVp6iMWXQt86fwYYVLyK8ggGj8EXZUEB8B5Z3j2E4WnJjqY9HTKoWC0yE7+
yJifAAS0dILnJCEqkccKkCPAh2iSxFrX7EAA3TLl3hHAXkqfZzP9SNibIef2+ayK
4Ee+YMAP0ezo18KKTdl1
=sl3X
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
