Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3LGKKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 05:10:14 -0500
Received: from top.free-electrons.com ([176.31.233.9]:57122 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752838Ab3LGKKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 05:10:11 -0500
Date: Sat, 7 Dec 2013 11:07:37 +0100
From: "maxime.ripard" <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: David Miller <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        "rob.herring" <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 02/10] net: stmmac: Honor DT parameter to force DMA store
 and forward mode
Message-ID: <20131207100737.GI24519@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-3-git-send-email-wens@csie.org>
 <20131206.162606.2277176361893801778.davem@davemloft.net>
 <CAGb2v67ZNtbQm+ZW5v_3wNbz1=oLhXks6gbTSjLYa=Nnoz8w-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nEsDIrWrg+hrB7l1"
Content-Disposition: inline
In-Reply-To: <CAGb2v67ZNtbQm+ZW5v_3wNbz1=oLhXks6gbTSjLYa=Nnoz8w-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nEsDIrWrg+hrB7l1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 07, 2013 at 09:23:27AM +0800, Chen-Yu Tsai wrote:
> Point taken. The current implementation will override settings passed from
> platform data. ORing the two would be better.

Platform_data and DT-based configuration are pretty unlikely to be
used together, so ORing it doesn't have much sense.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--nEsDIrWrg+hrB7l1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSovNpAAoJEBx+YmzsjxAgVS0P/AyW/lt3PWZIfXjd0qY32uvA
jj3QPwucvqo0KzQQezdUWX65TXHGLwpWTkduTsFw8pHqUz3YTpiY9KD9GrrSMICn
WB/Xd4AWcNTimFdLsoIHv8dcLUuK0iPNKyxjd5g+IxV+Py5dRkpXy1KTV+yL6T+8
D1AQY1gL9efBgYEiiOrPAILVKe2QfXr9PTsdV9gcMDFPbsfAW+XBGZBgYsmA98GP
Y0EshDP1XClbP4JY+PRzRAXoggPTK2bIDkVelObU8+75w8LOlPbiUu80W/Ji63vH
R+EzeZ+gjhwdEMP2utdDgFWuZUWIC7F4es3OIaSBRwInWcAuokd3BeqlH2JB556J
7jIdU8CSRbttr7I+mAzAmIPC8GYwc6aEvNTrR0yPge4ZmF4tz7bjNRpwk1mLDtxv
xOJ4u2TtnCjb8LRkIoLblTfb62MBz49vAy/ZOtoCbtUP169c5ltthX7c6WDYexk+
t/rLW5X9NO+DJ88TU8OP+75HqkrEi/5PLZyr0+aobTWaQLuDuMrIlq40Zl7wnL2A
kG3nFDdqNtnoeoCLxohRNb8ofHNcG9ozysZtUgYKNm9oF6HIyWXs9pZuJ9Hi0+RK
qJ0ZlVgDFPw31OzMSE8FuJ/ibFvU79pe56UuFnEDPKVX6dnBAI2B64K7EESrKxMp
xcdYffxuMaVhA4EbMHTB
=6Wxl
-----END PGP SIGNATURE-----

--nEsDIrWrg+hrB7l1--
