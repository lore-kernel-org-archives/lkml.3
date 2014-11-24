Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaKXJXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:23:18 -0500
Received: from sauhun.de ([89.238.76.85]:49767 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaKXJXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:23:16 -0500
Date: Mon, 24 Nov 2014 10:24:42 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Schwarz <max.schwarz@online.de>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: linux-next: build failure after merge of the i2c tree
Message-ID: <20141124092442.GA3733@katana>
References: <20141124201604.51aa3a82@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20141124201604.51aa3a82@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Caused by commit 5a6f1566f6a0 ("i2c: rk3x: handle dynamic clock rate
> changes correctly").

Yes, missing Kconfig dependency on COMMON_CLK. I'll add and push the fix
today. Thanks!



--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcvlZAAoJEBQN5MwUoCm2DUMP/ie4jG8s5M6w35GP7O47I4i5
Dcbxh5rQV51LLMYqm9T9+LEmDh98jVrnVeSUoS/86vP3lA3x/eKznWa+eX49vHBp
/NbYyMa/adQx+jpvQOya/Ixu+eyZEhPgpl74MBIFvBR6uqcAifWfD0QGLgehKF7E
Vr1zPv6wdTJ16PoIj3sTtbl33Z3HFA+809rrp7TTH7OKRZ1Zav+rewTlpOHRCOCn
ibGrEqsuEXtolSdEAIWOvt8Xq0fFcqBrc4Rj9XL4bw6WkU8yBij8eQcrJ4LtvbyN
szHBRPtaeJxMua8kg+VZto0oUmQyb7nC8w4eYWwiII/x9EWiPYNN9hW2ZWKRfoib
y7eTa1ci/OpxwLMyW5y+hpWk05+63KHuSQLoKkokXNaAtl1P86cXUFZd1viYKz28
qdgtaa2P1vjj4Vj4L3S7zKpv4261XsbBdacbI2/ASGQz+sCYVzfk7cRzy5fe/z+0
M/qius3tRqy1wbAXm8CbDE/sVPYuy3OQCAD1tj9dEZWefQyDloST/iksQNyKHNi8
cnmpBkcFPrrxafKWhhpb3vPcNeawetPyH2vWZ9gI+mHzehEx3m5PO+NlLizpUaSg
dBORZoqFyjxw5ljLOmzsFTxtYdI0SzqrAGOMzZPGFKpjCIkxyXDX7IJfU1cndGOv
ymmrsN8jmzWLAQRSX91Z
=8FhH
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
