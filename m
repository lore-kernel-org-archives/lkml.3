Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaBTXgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:36:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47781 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaBTXgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:36:37 -0500
Date: Fri, 21 Feb 2014 08:36:22 +0900
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Message-ID: <20140220233622.GE12197@sirena.org.uk>
References: <1392926295-23735-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cPi+lWm09sJ+d57q"
Content-Disposition: inline
In-Reply-To: <1392926295-23735-1-git-send-email-shuah.kh@samsung.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.141.82
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Change dummy supplies error message to
 a warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cPi+lWm09sJ+d57q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 12:58:15PM -0700, Shuah Khan wrote:
> Change "dummy supplies not allowed" error message to warning instead, as this
> is a just warning message with no change to the behavior.

Applied, thanks.  I added a CC to stable since people are going to
notice it on PCs with the other bug fixes.

--cPi+lWm09sJ+d57q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBpFzAAoJELSic+t+oim9RkcQAJLe7ePHGVVOBgX/8hzgxhmv
/b5m8nNZ8LPG23AEs7FhgvaE1+s8Nt73qZOfhMOodID540CmB33TleqEZLDfmMJR
Pk7p+WW9CwZWi3EaMv3LFzWRThq9mZnzgrVqFez4fyrXGrGI7Ajel5b8M5pC3YH1
DgSQs0gkdZmE7BDTVt3y9sSeZCTbSExPjWTb4JuXuyiuBmTw+bWG0UrnU/6kFqXT
DXSfGdj9py2TjV628PEmBiH+fdGLjvdrgyKYcbdUmw9T0bpYN6hUHMxRJOOKN+2Q
ihrxZ97HUlOkcrRqy5RZLX+Z4mECzTzhsmzMO/DOF8AM7i9PuPheCiFsk29se39b
2fvEy77c+ivtnLzfeRyctypJpArJlXpYOMUVord14WkeU4ooj+PccFG1o7MNU4UF
JkiX9gKs0jbb1rf7MKYbB0f1hvQSgExYOeyZhm070vbLB37J1hUQip6pK0RIz1Et
keb/z5LNl/FnrLTQQrxeBiuAUAXc1nOGuj8VvACoEFPgmn1Eyjy/NTqSnv7S0JNm
GbRWt97b/HHRqUQqa2SRr5f/S7AVWxcgzxlgdCjhVU1x1zMaEeh7PQ6W2XHFereO
TNQPB0S7d8cYlfUZXhy42KSFRIX78ZSC8jhr2T/iNKPi5SV/64qmCE3iyojHr9C2
WUYdQJz4cZZfRw/c7Q3+
=MJ2S
-----END PGP SIGNATURE-----

--cPi+lWm09sJ+d57q--
