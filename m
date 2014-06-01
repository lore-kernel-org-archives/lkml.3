Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaFASUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 14:20:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50152 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaFASUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 14:20:13 -0400
Date: Sun, 1 Jun 2014 19:19:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140601181959.GL5099@sirena.org.uk>
References: <1400580736-29410-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Cwqj9FHWD4ffUzp"
Content-Disposition: inline
In-Reply-To: <1400580736-29410-1-git-send-email-alban.bedel@avionic-design.de>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: core: Fix the init of DT defined fixed
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Cwqj9FHWD4ffUzp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2014 at 12:12:16PM +0200, Alban Bedel wrote:
> When a regulator is defined using DT and it has a single voltage the
> regulator init always tries to apply this voltage. However it fails if
> the regulator isn't settable because it is using an internal low level
> function. To overcome this we now first query the regulator and only
> set it if needed.

Applied, thanks.

--4Cwqj9FHWD4ffUzp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTi27LAAoJELSic+t+oim9hRIP/3M2ew5EkdxfE++6nRFQSmqN
bmtSuCZ7WsVVVgQfwGfdQouqU7w+h7vDCjNTus5kC36NIvCFsqDITo+gFEKjawX4
hwlCOqL7UKxFhqgs5Q/4u1xLz/pn1jfoMLblqauUzvML2NqDmb4ywd8d8KPSJOQx
9lllCUPniuVa7l9hAS3ZvZdRlnglibEQM/FbIbQNAWsaqrfkqXr5jbX5ES4cafIm
JMhKuFVIdanFh7nSdBJsqSLcCRuaN/q/1YsAsFLVhZ1Os1fmF9oiSRCE0Oii5Pao
XWPZ1EgXmkmNxZcTAbMWqSsuKKsYTgz44mtLgw+oHsWsi3SjHKuYXHyg8I4/dyAx
TXv71yb4Vdkrsq5RdQH71zrX1zxGsiZlmfGkBtMvh90g1kQ3EsmZXgYTQQtDPQ8n
PULX32sHxVMgb5Y3DLRFxxYiwAA95JM8INbOhvoFIcS9OD4BOUN65kZTd1OKNYNf
+BRBu9vPXI8G2GK7T6hwn8QuSlIA9ewOClsW0r59l4jE5kdo5o/c/s8ktrqiYMWE
EbWoZWC6LzJmheLBRCFHQ0W9IZQRaki08B3s1dwJFUQdNIofipHnVZRCFKxBWAdp
QAg3t9yLbo0PE6TReoFknm6oK4S0A2S/Udf+ZRGtCav6MIbnBmkWQFsz5tKHUwRn
7RRY1NsepWS4Odfbd+1a
=pC7F
-----END PGP SIGNATURE-----

--4Cwqj9FHWD4ffUzp--
