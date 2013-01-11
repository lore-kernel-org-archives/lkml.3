Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3AKJQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:16:08 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56801 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab3AKJQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:16:04 -0500
Message-ID: <50EFD824.3010502@imgtec.com>
Date: Fri, 11 Jan 2013 09:15:16 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <20130111103442.b80ddbfb11ef322ed28ca3b3@canb.auug.org.au>
In-Reply-To: <20130111103442.b80ddbfb11ef322ed28ca3b3@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig9A398C600C74AEA053665CC8"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_11_09_16_01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig9A398C600C74AEA053665CC8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/01/13 23:34, Stephen Rothwell wrote:
> You really should not base development work on linux-next and before I
> can include it there you will need to rebase it onto Linus' tree (or so=
me
> other tree that does not rebase).  Its OK to test by doing a merge with=

> linux-next ...

Thanks for the info Stephen. So I suppose if the patchset depended on
things in -next the normal way to do it would be to merge in the
individual trees I needed first?

Cheers
James


--------------enig9A398C600C74AEA053665CC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ79grAAoJEKHZs+irPybfUNIP/A3vfrCBCfUULMGteFjFOqgv
F7EY5et8Xw9OnZemgEzayjBxeVSJMul7FiSoo+O8YNHNZt9MGamWdl2uCL2FZjgL
KIVq6yP3yPfhXb/+i9uVn/ZJU55PV+4nFfd0Z0JYBMoJ/6sD2Lgw7VGfn4nGK7kN
AiMAosshoP4TuJkkxpmQRV3wbXtjmd3+GMshX7y3TRZO7zhoy+FpeMKFa3/Q3b+u
Npjfq9YWZmoVo/9oHnv7AV4dZlINmrJl335VPjxQQG1gbKg5TaXo3A7cNkD6ygBI
BjSbwWU57ajW+R+Y8WyIQM/6sfEdXeVEcy3kNw4o0ge88qXcNdsAsCAPHS0Zs+SC
uTFoue/6dAIgC7HUgLFZDnx9B7zn1RjeZkQ14082wZ0hP/g6hTfr7bSop0BuFW9W
k08l4O2TV2nsXQ1gk4r9Vr1zfL2iBJUNgjXfl8dwi1IbW46Qcf/6JsTZwUImw01F
/gdIhMCtOJet1HMmw937K2Sg4PVTbRKoKy5+O4yUnn4td1Mz9k5xLsnsfDfwU63I
UxLu5e/m3qEciEjWRCsb/Ko1V6l4ioXfaKy7BOAOjlixTeOcSCxeyuMo1T1TE2V0
xk7CvW/iQvukH40bgmc98AcEvIJyGve1XldDj4BzXJd6uvtHYVW2mn18RjTo7Lci
4lg7hz20B81ZlWKdWnMr
=Kuri
-----END PGP SIGNATURE-----

--------------enig9A398C600C74AEA053665CC8--

