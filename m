Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbaIZPM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:12:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:39913 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbaIZPMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:12:24 -0400
Date: Fri, 26 Sep 2014 17:12:17 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] power: charger-manager: Fix NULL pointer exception with
 missing cm-fuel-gauge
Message-ID: <20140926151216.GA21641@earth.universe>
References: <1411730823-9667-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1411730823-9667-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 26, 2014 at 01:27:03PM +0200, Krzysztof Kozlowski wrote:
> NULL pointer exception happens during charger-manager probe if
> 'cm-fuel-gauge' property is not present.
>=20
> ...
>=20
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 856ee6115e2d ("charger-manager: Support deivce tree in charger man=
ager driver")

http://git.infradead.org/battery-2.6.git/commit/661a88860274e059fdb744dfaa9=
8c045db7b5d1d

-- Sebastian

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUJYJQAAoJENju1/PIO/qaC0cQAIyq8Kqn5b+O+glUpIsVDROV
v97wyWTEpH3nTS/JlZnKJ5U3b0HwWDbFJRfCWtYuh57L5qFAWBP9dsK2U3yvRlJz
CIcEQHnDLzVgBNsRlmZDSvP9B5wdAIWRYsDviPezSQrglQQxWr4Qvxj3T3O/Q7JR
qmNF6mKpNFVELFy3/1+qRabtdo01T+PR4h7q3T3MYVeqUgQmdJOCTp+TtLb7geHU
26fouFuMvWB23jYr1vE4NtQbtMvoI00uUaAhQmf3saxTKsuj610lc1L4dul7jGsv
S1ivONWNHWhLd2vcVeGH9UQHobkJ7K2gDTd81d+k2fsbFGJZJe5mTMFnKl18CVhM
Dul3oo5EPtIoc00Xsm4EuJ6x84/izaNzxxfe6/hsq9AXPn4okV16qHI7nM8dNmkg
oOKp3CyKrkYNtU6TYaHvtE/XRAciQCsCVY8KcnZ8J4el4HZltmif0QrZOmKQB+1A
h27U6IrZFRbneK6Am4nounS4DXX3ZoD8xvEIYCzna69+6Re0kCGvs5+YRQFsOfri
KSk3rz7ixkqRlTZ6rGKuY2aqSZQfZkT+AvQ9FO/i0uoQ7Zow7lMuK8uf69uef+kz
jKyNtevTQFqDZZKpOxBGaA0XVcuTFXIQvXJcZ0gaehNg9mAnfEUnQ/enaS3mZPTJ
YdJ4KgNt7EXx8zR2u+UB
=zS5o
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
