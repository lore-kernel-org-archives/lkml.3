Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3JaPix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:38:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50348 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3JaPiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:38:51 -0400
Date: Thu, 31 Oct 2013 08:38:33 -0700
From: Mark Brown <broonie@kernel.org>
To: srinivas.kandagatla@st.com
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20131031153833.GE2493@sirena.org.uk>
References: <1383220389-18420-1-git-send-email-srinivas.kandagatla@st.com>
 <1383220441-18519-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z3ND3gJe4e1E4uwh"
Content-Disposition: inline
In-Reply-To: <1383220441-18519-1-git-send-email-srinivas.kandagatla@st.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 63.239.94.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC 2/2] regmap: move to using BITS_MASK macro
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z3ND3gJe4e1E4uwh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2013 at 11:54:01AM +0000, srinivas.kandagatla@st.com wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>=20
> This patch uses the new BITS_MASK macro for generating mask for multiple
> bits.

Acked-by: Mark Brown <broonie@linaro.org>

Or I can apply both.  There's plenty of other places this could be used.

--z3ND3gJe4e1E4uwh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJScnl1AAoJELSic+t+oim9P4IQAInD9V+XheB9bSzlhWAwrUaz
lwB0h4Q+KGkPPseICSsr8VdG7Bj8XLh3LRIhob2fymnwQhvEDNlmukG8SZSncG8D
NQ2NVDpQjn0J+0G3rqp5LIcyDWIFjAZjrxBuFwzw0m4W06Oko+fGkLFP2YY5XsSf
X1nxITlevnQCXAKkUoV4Qgnw1B9IBrofDokmakYd/kJQUkdIJk+3zpuNU0bj0K8i
/edlT2YgrSMVaKtusBi3QwGHODBbPfP5SS2Usu0wlO6ypbDbVxNcAvB1Wa5PGmNy
rwD5/2e6xeJY3zgfxuPhQZahAY3HhGR6N2qGpbjuLesdt0mveIM/Rd37q/BxDQEE
4VdzJxgUWq8puAtbveCU76zLvbIRN+cTzblXVXk6lDlljeGRG/g76fPMWublOOBF
+jiWZn7x0oeSwDPUN43oNmWRrVZtr/Ua5EcEfRYHlviuyr6pzRcLBvNdZkThkWVC
e8dH5BYR3BHAiFRXE37BL4RQhVlCPKRJFR/mvToR0kU0p91dZ7TBi89N+vOsaiGB
6NDDd017SgIC/Y6XLoKyZByQTFiJJGcSOZLarhZLIDHlQg5XlIupJqS5zdaCvhCb
aNgQ5g00V20vGQjvbkjhtCsL7QHZB6SV/BW8TNnkfPcVTkrGohIyBzZ6838AUpeE
0oK2MMaMAcfppgRi3cDc
=PK8b
-----END PGP SIGNATURE-----

--z3ND3gJe4e1E4uwh--
