Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab3FRL7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:59:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54529 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab3FRL7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:59:18 -0400
Date: Tue, 18 Jun 2013 12:59:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com,
        sachin.kamat@linaro.org, patches@linaro.org,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130618115910.GN1403@sirena.org.uk>
References: <1370864113-17895-12-git-send-email-tushar.behera@linaro.org>
 <1371528907-14425-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ujdcy72QwKYdVeZs"
Content-Disposition: inline
In-Reply-To: <1371528907-14425-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 11/15] regulator: ti-abb: Convert to use
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ujdcy72QwKYdVeZs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 18, 2013 at 09:45:07AM +0530, Tushar Behera wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().

I've applied this.  In future please do remember that if you're not
sending a patch series you shouldn't mark it as being part of one,
people will only wonder where the rest of the series is and miss things.
You haven't sent me 15 patches, you've sent me a single patch.

--Ujdcy72QwKYdVeZs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwEuLAAoJELSic+t+oim9e5sQAIpqE/wLW/aj6Co/+HFbk5Bp
8gF82aOTu4j7+RGalKVi/2nxmOrficSjxVYnRPOIyyBtexFmf/mh+dRMxzISww0I
5WooayZI5vPRs+uqNUwGJIL954z8EMCMCi8QecdiSYzr71GpfCjJSkdEQHRI8eq/
FO1C05NhpX/JS8hGE3JdLQvUVFGRg5/sjzeVPEJnPhQVlQrW/LE0ovdG5rjWCKCI
hfyEoJpsrf1UVcqpWOVlZv5Qn74+Wev/WumXFOQkPAjDZlgCHofZW4fK6uof6BAR
kXBLLQn3u02GeM5yIEdb9zPPyjpbbHeNEp22Xae3NOcXEImnP40J6zDFyBI4KOkK
KYb+02J98GINwXAkMPRve0TEp9NGFiveUgGSEsCwPms6FnUkiCVl8rkkm2Pyedgl
e2Fd6A3Xz6iAUVQPQ2eYS93mvOzxmJBXpvtX5xuSwZcTrIdVtGVZodz0vLH2UYhF
NHZouql3tcqI6vV7Rx09u1uOVykwFiaXGuTDBB0icYa3ZpkvD1lUT7ZPjuS9ZtqL
Hf//DpjsOgvF2qofgNLYCrLlyYXdQd4+Y0e2n8AEmUrGpH7+7apXhGb0BTqj4ikG
QEDe0t7dupptHfAu5ArpPcq1IPC1t2IBmceuBP+XIt37dQLrvZu4abSKdz6A4Tgm
/GVvHH3tqIpgZFHKEBrQ
=MnuF
-----END PGP SIGNATURE-----

--Ujdcy72QwKYdVeZs--
