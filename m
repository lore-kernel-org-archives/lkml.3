Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaDAP6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:58:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49979 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaDAP63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:58:29 -0400
Date: Tue, 1 Apr 2014 16:58:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Olof Johansson <olof@lixom.net>
Message-ID: <20140401155815.GY2269@sirena.org.uk>
References: <1395984022-8284-1-git-send-email-tushar.behera@linaro.org>
 <1395984022-8284-3-git-send-email-tushar.behera@linaro.org>
 <20140328102220.GU30768@sirena.org.uk>
 <CAHbNUh0dwBWfT=AAYP_W2yx2xkbnjbhOBF_PSKrLdv1VaUv9Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w1kQleqTSl6UE45G"
Content-Disposition: inline
In-Reply-To: <CAHbNUh0dwBWfT=AAYP_W2yx2xkbnjbhOBF_PSKrLdv1VaUv9Sw@mail.gmail.com>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: core: Add reg_ignore_unused to keep boot
 time regulators enabled
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w1kQleqTSl6UE45G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 01, 2014 at 06:59:04PM +0530, Tushar Behera wrote:

> I agree with your point that it may lead developers to write bad DTs,
> but it becomes quite helpful while debugging issues.

So make what you're trying to do look more like a debug option then...
though to be honest given how easy things are to resolve and the prints
that are there already I'm not sure it's that helpful.

--w1kQleqTSl6UE45G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOuIUAAoJELSic+t+oim9g8sQAJcDQlty5V4NA2Dt3Sp+jkug
A2yKoC/Ii0LyCeixnI4qQhLNiqJAMaNRjUmKBCQtFJeIAscXHux+p9k6uVOga77e
3E+R0iNNdNtav6q6jWPs3JuceQg7nZao99GQMRlHcrwMvnMLdImmf21E5qItsO3O
j7e8WkjIyLMDxt0vjBfINx67Qa6/Piu39ItlnBNmyojXhUH9YUP7Wc4cSzSjvkRV
gnJkgz8JvqvFk55OCBK6oIGlBTmFN6Duuy+yvBO+qvHNG+29QNxtSBXZr9jbB0ZK
ixbBl/oeARkjyT+2Ay1GBJQj3kef3g212j2kgUNFZ6C4sLFZuh8myYDrCPGPvAgg
sGi2rJTcnIQyt0UvusLqrOqD3Jn1O3gZk7uZz0PdvRFbbjLPZ3jJvIZolsIBO1tk
p2en6ANJnEFfrWrK/inQo4I/Rx7dmWnu/3tDJ+tdRf/fAJgutLCG/dBrVTSkGZDG
+VoXRK5fq0OUTo+dyvMZaVBaIDgRx7oGde4RHePlTMHieBruN9DDiqiFfHId/WFr
eg9Noay1+7DVnmyTwaQmqlubZ+BX8d/nmluwjRyh1YlDGjnFnXC4VGZ8AS4sEbGG
EoK+PsNSr6dTzkm0YxgoPeem2NYxWGYRrBExx22AZ7rC2DoGnaIEkyoFSwm3GBy2
whsqhEbG9ewCd3TOQcjL
=UDuA
-----END PGP SIGNATURE-----

--w1kQleqTSl6UE45G--
