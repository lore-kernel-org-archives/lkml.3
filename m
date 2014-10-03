Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaJCA1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 20:27:13 -0400
Received: from sauhun.de ([89.238.76.85]:34403 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbaJCA0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 20:26:51 -0400
Date: Fri, 3 Oct 2014 02:27:21 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Alexandru M Stan <amstan@chromium.org>
Cc: Max Schwarz <max.schwarz@online.de>, Doug Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>, addy ke <addy.ke@rock-chips.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        ZhengShunQian <zhengsq@rock-chips.com>,
        linux-rockchip@lists.infradead.org, heiko@sntech.de,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: rk3x: fix 0 length write transfers
Message-ID: <20141003002721.GC1323@katana>
References: <1412185241-24950-1-git-send-email-amstan@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
In-Reply-To: <1412185241-24950-1-git-send-email-amstan@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2014 at 10:40:41AM -0700, Alexandru M Stan wrote:
> i2cdetect -q was broken (everything was a false positive, and no transfer=
s were
> actually being sent over i2c). The way it works is by sending a 0 length =
write
> request and checking for NACK. This patch fixes the 0 length writes and a=
ctually
> sends them.
>=20
> Reported-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Alexandru M Stan <amstan@chromium.org>

Applied to for-current, thanks!


--32u276st3Jlj2kUU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULe1pAAoJEBQN5MwUoCm2hWIQAIpcr1HzjtqvzPVcuhJfV3Vn
qo5ZzuxFtclnU9U8mwAJA2Y5HS2BejHK0x9pH++UqfefPp0lQ3aotK1bEmHBX41B
qYLONBgCL/k5IYvallCmaEIsUPMbKz7RlH+1AKp4lkYnn1zxf6MQxCgxXaZ/LlGO
15AhRYyMJEdMUzkhIg7fRreeLSmIobC7OzxeR9CHL8j84f5ukr5NyOAkncUdF7sg
0+h0e0XDUdFma79sAKy4xGJuEGjqhEtPQstCagvmkjVd5I/qBIVoNe2oApeQ9pmp
l8vDUKuqC+z9aEOyRd7hshSrrpBmJDQQXavnFbeMJK2rNLAfvNCybXFBHRo1qIVt
Bt6uRS+nyClF0riRPDX8zim+vNUsyNAqAPVADOMLKfAX+Z70EFBKFgWV2gRT+Y/W
X3cFWOWpzPXUXZuWLnAyTbY3XBFDqbf0BAJ5Hvdk4wkn7TGWatq+y5a1uDlFgtDX
PB3cOzH8g/xkK4GTGmfvf/elk4qWJvZfEFzzUg7p09NYdiW4H8irsNGPxXRzLDlB
drV9HsIfmpKiW9fnFMt3esKTX/2pxfpqWq1x0y3HldwBwNy9Mp8l1B26xYtk0mUn
P1P49AZFvbnuSik37LW2OvOuDR22oyLhrOonRuBHdDnC0Ni4H4wEpjuUuZR4R6Av
cbTarbpkcuzu/S9IXgXu
=M0zr
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
