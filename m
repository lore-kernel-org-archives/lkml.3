Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbaI3XB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:01:26 -0400
Received: from ozlabs.org ([103.22.144.67]:54629 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaI3XBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:01:25 -0400
Date: Wed, 1 Oct 2014 09:01:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error trying to fetch the mpc5xxx tree
Message-ID: <20141001090115.44146aa9@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mT7hq8F1hZa0nG6GxGaE2cM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mT7hq8F1hZa0nG6GxGaE2cM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Anatolij,

Attempting to fetch the mpc5xxx tree
(git://git.denx.de/linux-2.6-agust.git#next) produces this error:

fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mT7hq8F1hZa0nG6GxGaE2cM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUKzZAAAoJEMDTa8Ir7ZwVTCYP/AjAbzkUJO3eyvODr85B5bgH
7hMCv7opVrMPpeCqK37pYn1hizg4Jlaxk5Chma2Mot7Qe+7w6zBhu5rXh8PgTXjR
7XztKQmeKdy2VOSWumd34ljIEiFuuuSf413lv09UWtgrXRZ/n1PtKCjUblBAIS4g
BrXGISCE9BcXpC3qwymjhaTbcw06h9/aYGkAQ0n+FnaBY05yKOWnwzGT1VcdZZqT
9JShujQYn9VqHFwJvtcj2e1LvQEd7b45BmaSvVBzlV9djhyfB4JpgIOkUtdfAKk1
hIWLR/9FESMYF7u5foI79N8gTi+00vtudM90lTkiEEURcW7yiViu3/mIuM4iYZqG
dolrKhkmxqYRtqjgwUytk0O8pKqIsX5VArdb7kH43c7goms2bC3TSlZXlmyrr+KK
VVNGFHtOoNLFKrmwSsq7NVR7P8KnZrpWwyOf7NcY08AjKr7xXY0aQQ3faGQfxStg
qQK/hiC/hrl+DQq5g1D+B5xZi/XDwWNIpEb2QSqrXVWvnrtpNMU9t/yAlX+Y+MEA
4QsOiGLKYvwor1lonrhV1XllZoEqrhRkd5IBkyd7alwQ6xiD/SInRtJ8XEfNjMPW
VaJZK5LBLP33kIwfOikIrFyfEyYKncfjiFfqJueAPCD9H83oq+LInkjE+p2VoHZF
J2zNB243aNnMLKPqLedp
=UZvU
-----END PGP SIGNATURE-----

--Sig_/mT7hq8F1hZa0nG6GxGaE2cM--
