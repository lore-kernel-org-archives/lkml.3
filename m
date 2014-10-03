Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaJCA0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 20:26:49 -0400
Received: from sauhun.de ([89.238.76.85]:34400 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaJCA0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 20:26:48 -0400
Date: Fri, 3 Oct 2014 02:27:06 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Max Schwarz <max.schwarz@online.de>
Cc: Alexandru M Stan <amstan@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>, addy ke <addy.ke@rock-chips.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        ZhengShunQian <zhengsq@rock-chips.com>,
        linux-rockchip@lists.infradead.org, heiko@sntech.de,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: rk3x: fix 0 length write transfers
Message-ID: <20141003002706.GB1323@katana>
References: <1412185241-24950-1-git-send-email-amstan@chromium.org>
 <2239755.0FknEeHYOT@typ>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <2239755.0FknEeHYOT@typ>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Reviewed-By: Max Schwarz <max.schwarz@online.de>
> Tested-By: Max Schwarz <max.schwarz@online.de>

Checkpatch says:=20

WARNING: 'Tested-by:' is the preferred signature form

Same 'Reviewed-by:'

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULe1aAAoJEBQN5MwUoCm2x2gQAIWXDW86kr0jXwbodTsASKpn
j+DhvJMHTebcEH6q8GomphUJVi5mYLkpBR/V/PP1FnDlM+cICpghFtgj0W81PSZC
sZxvOQq67Prfw/du38O9G7uXPTkZv+ud81grv6uQQkI06RRx1QT8lptfRYZmhqZE
q2OqvCLCMQ//ARb+WchVrYGPQ1asSoUBEK695o9QfsH3jMsCze0TU3zUjQVaeHIv
+BcNJLSfCS7UqF7c78MZMyAWNCzCKLAQ5Vo/7PMuU2OA+matb5SkhIKNx86T2+VA
QOSQVcod1hUFfcRyDWPm/6V53TeaNP/BVCW0ujLmx3nWsKBhdIChAhtMLRIx0hm4
fNAhOEKOOMKL0GhEng4y1miXufVY6nWOnJCK9+M63iIj5k2p8tpstAb63b6VaOQZ
nVF3MdUxysjEBV+fSTFEscjirH3BQiVAoKTnbUUMsVCZokCWsDT5FlWfX0kSpEl2
bA358r/OSQfwqNrdCg7bDcYtBNLIzBob+F2nz9LsdXLu6/BfsSQUAH59dnLoyOpW
L2NmhSuYtU5RTqe/+RWudh0RUlmYt4lbo/+sN2quCwg9Wj5iZEJz72jxSPO0i1e6
/nHJj5k7FAZAYUOqbTmNeZm9KkCYo4kgPdmrF29gDDxfalL2m+m+wq0GgReiUIf1
BfnwTWLJvjoZYqBrJ7T1
=EcGO
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
