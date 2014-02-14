Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaBOKIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:08:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60357 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaBOKIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:08:05 -0500
Date: Fri, 14 Feb 2014 21:15:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214211504.GF4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-8-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Te7Ox1lCLZcbqNre"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-8-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/16] regulator: act8865: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Te7Ox1lCLZcbqNre
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:54PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--Te7Ox1lCLZcbqNre
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/odVAAoJELSic+t+oim9/foP/3wE0FSMQUsNPRLVf30spE0c
xpl3oQ3hseMne52o3CZP7O+1dQvZ0ckg0rP4DYDyOJX3w0v69pDeE8BbC5MUY6H/
OxOSuEb151hwGqbSXRd9TKaB+ximd+Ik1C76RRjlvleKamAPpKr3/nZTTC3ZA5VI
3ZUVcJE3mUqT+IMgIQ1EJj49/oSgDJXWNtPy1iSi+m3CEOoPJr3Wai82Atm4yWn9
8zrx/hhKz6sFZ3nM94sElb+64yhRCopyFtyfhcs7F4Dd30BxEaqsE8gajvxt02e3
n+xo78dVQDYFT3B8gh6CDiVAWBVL1JKSBNHcSImiRocPOXrOdseA3GDkxSZYzNkg
wyKjX13T+97W2j35NlMxE/IJRiSPwlUbih3x+eAy+qppkpYhlBgeqHHqvjWFjtFn
uA6G6BX1CNstgw0mvLPmPUpdPm8sl7WFGfrVJrUp5Fo+G24NtLYWHQbWBzUI8cyV
UQSDyTYMrmcOeEanK6G/OqFv9kkQ7EY0A8BXmX/0sb1Ss+wQVuHIYCJ/jAJoS4QL
IActyEz41wsDIaOW9+LKx7dQ7Swi0T7Q+t/2kbx66cCn2+dVtaMgmR4gVC0wQkNs
98ClV+c6aVV8MqBkxzdfogIKZwXzjx2hgYpNOgjkEe5NqO6NPd9g/akrySYbGOn+
UDRyD/0LDXggvuwygB+s
=xEbJ
-----END PGP SIGNATURE-----

--Te7Ox1lCLZcbqNre--
