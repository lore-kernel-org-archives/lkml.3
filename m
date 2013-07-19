Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608Ab3GSRYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:24:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41333 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3GSRYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:24:53 -0400
Date: Fri, 19 Jul 2013 18:24:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: "Joseph(Yossi) Hanin" <yhanin@marvell.com>, Yi Zhang <yizhang@marvell.com>,
        Chao Xie <chao.xie@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130719172429.GP9858@sirena.org.uk>
References: <1374210382.895.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9g2r9e2kvGs7M7R"
Content-Disposition: inline
In-Reply-To: <1374210382.895.2.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: 88pm800: Add missing n_voltages setting for
 bucks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9g2r9e2kvGs7M7R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 19, 2013 at 01:06:22PM +0800, Axel Lin wrote:
> Some regulator APIs are broken if n_voltages setting is not set.
> e.g. regulator_count_voltages(), regulator_list_voltage(), and
> regulator_can_change_voltage() do not work if n_voltages setting is missing.

Applied, thanks.

--v9g2r9e2kvGs7M7R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR6XZKAAoJELSic+t+oim9Bk4P/AycUAb124NPf7KHqq1drk7F
NuF1/28AqTlc0FGuGE5z230HcNuWJcwydwSLwCQbFCXZImS8lVh3IxMQ8X0Y9VfZ
fSXRbYzupHcKSLxODieGc58CBuNlbYWcg98yTYkOY8KywR5NMY3YKCIJKRAOu7o1
B52KljavwmsoAaS+Rpz7oxEf1LkDZWboQHWzYEumOVLKgZIt0wFISqye5m/53UvX
5RwsyT4yJtLQ/oruxbLKuhG137JrPVnEVJimEPCTKsOxZlupwjVBeOn9oGUHXAIe
SBBO+9lLp87kq3a3ZHHXphBa9XZIVPUWv1uMmspBEP1G3QUE/jBC/ZMjrwrcvDht
/+J6LOnt2WJvbZYe5Mvm36ycICtk+XGOm+rpESK7+PYY0UyJ6meub6PZRFaYcAQY
6bNZEAFUGrZlxy66wk1BYATHYdBBj/abaTwvzk5YFwrCCdKaH3yf7BFvFhjiPdZT
oNw9ISp9eMR0LYwr+VQedIjRkK5QXZXMb5jt09vWlun8rJWJmPWKfvEYWRoXkAV8
mA49QPK4OwDLdYFZiDHzACYBgbVKY3DguLr8RfRVfay2penNMIW44n53sgu6I4iG
9w0Kc1lTDv+gfFggavo7uLPm+Ny5aGzysAuZ2JWbfClkqoTGCr6WQeDiqb8HGiGO
SlzInSkRHmopfDolWxg6
=D9PR
-----END PGP SIGNATURE-----

--v9g2r9e2kvGs7M7R--
