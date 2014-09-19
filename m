Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbaISUl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:41:29 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757876AbaISUl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:41:27 -0400
Message-ID: <541C94F1.9020206@nod.at>
Date: Fri, 19 Sep 2014 22:41:21 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 7/7] sched: Silence nested-externs warnings
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com> <1411140580-20909-8-git-send-email-jeffrey.t.kirsher@intel.com> <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com> <11081C57-805A-44F8-9768-271DC6B27F76@intel.com>
In-Reply-To: <11081C57-805A-44F8-9768-271DC6B27F76@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="6SEEuo15mx4CkX54CiqePiKU0HvUNI1Ip"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6SEEuo15mx4CkX54CiqePiKU0HvUNI1Ip
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 19.09.2014 22:34, schrieb Rustad, Mark D:
> Excellent. I'll try adding an include of delayacct.h instead. My patch =
was based on the assumption that the existing code was wanted in that for=
m for some reason, so the patch served a purpose in recognizing that it i=
sn't. So the macros have served a purpose before even being in place. :-)=


I bet sched.h does not include delayacct.h for a good reason.
sched.h is included in a lot of files, maybe delayacct.h introduces nasty=
 dependency issues.
You'll find out. ;-)

Thanks,
//richard


--6SEEuo15mx4CkX54CiqePiKU0HvUNI1Ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUHJTyAAoJEPmeIjfg4UaavQUP/0S9EgrxcUoGLFFkEWY7z2EJ
mBMER+MGeuXHsPR1EYineFg18XJ+Jl3N+A2539v15dh9VrqPxPBW1dcE2/MqcP8T
xtd403PRFMgNIrVei5JkkgZSUu5xzondH5lcxwtPw0iDm0ZE2fh4CRFRGy2SxCGw
CY9aRs8CQJNYAlUcKYm/pPHmgTTqDaHz8w6tEIzUZ+heEQbGKG+wo1cJ3Bi7Kn2O
lQgfLPWNBTUm9Nqsy7PFsZ8f02TzQZdKRXTpTTXn2l4au0XjBIq9LZ8XYYyWkfFT
lmmEUZIoXnByhIVqXZIf9x6GP4L5iZ5oMeTNpmKK4zUFc2OBu/Q5wp7XleEZB9ji
V9P4udpoI2hyvxpn0PIZr/Gl05qkXFwOsPvCSB/pOOch/a0xi7JhGqPYgOAURZnf
oOfGYAf2sBqHDzJy+718dk9bCZfaxc+tccFc7N1P1iUeJEA+SiAWa3Dw8oeTuC9v
xVt/lglWWeXiHTDtsy3MSc1yPQOIjcaPE+tPJfmDY6EGpAGPpC1MVr2sBDdHOq+f
FiHk7V21s3ddHR6xhT6CVVwcNZE9P4qBsWufLJbg/N6S0URVd0ipGr4InWuLdBXT
xhXepiyWGGIN+hBabH2MHA7qQcva/FISrrU8m8z3hNZ89a5EcFVpdNHTvIwAlsDd
yZfAznqe96lomS4f9UmP
=Y3nE
-----END PGP SIGNATURE-----

--6SEEuo15mx4CkX54CiqePiKU0HvUNI1Ip--
