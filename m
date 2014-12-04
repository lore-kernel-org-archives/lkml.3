Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaLDTEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 14:04:04 -0500
Received: from sauhun.de ([89.238.76.85]:34600 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaLDTEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 14:04:01 -0500
Date: Thu, 4 Dec 2014 20:03:43 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Max Schwarz <max.schwarz@online.de>,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Chris <zyw@rock-chips.com>,
        =?utf-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>, caesar <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: Re: [PATCH v2] i2c: rk3x: fix bug that cause measured high_ns
 doesn't meet I2C spec
Message-ID: <20141204190342.GM7944@katana>
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
 <1417574237-4328-1-git-send-email-addy.ke@rock-chips.com>
 <20141203111518.GB1039@katana>
 <CAD=FV=X5inPWZakhgDX0dX=1CWXygEi3_AH9FVFWXYT3LZA5bg@mail.gmail.com>
 <20141204184046.GL7944@katana>
 <CAD=FV=Vp3hwxbDzb+FUhNXy8qW8fTCkgd67jRDV3foT0o9HQuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AQYPrgrEUc/1pSX1"
Content-Disposition: inline
In-Reply-To: <CAD=FV=Vp3hwxbDzb+FUhNXy8qW8fTCkgd67jRDV3foT0o9HQuQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AQYPrgrEUc/1pSX1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > New binding should have the "-ns" suffix, right? So, I'd vote to add the
> > suffix to the new bindings and deprecate the ones used in the designware
> > driver: "i2c-scl-rising-time-ns" and "i2c-scl-falling-time-ns"
> >
> > It might be a little more work now, but it will help us in the future,
> > because it is the correct way to do it.
>=20
> OK, that sounds fair.  You're OK with my proposal otherwise?

Yes.

> Are you looking for Addy or me to submit a patch supporting the "-ns"
> suffix on the Designware i2c driver, or should we just use the "-ns"
> suffix in the Rockchip driver and assume someone will later add
> support for the new binding in the Designware i2c driver?

I'd be really happy if you can do it. I'd love to have consistency right
away.


--AQYPrgrEUc/1pSX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgLAOAAoJEBQN5MwUoCm2MZoP/2+ZtwoRTOxH7xJMmnmngJTI
y4CXTCTr8ES9GRvGizq0oeMS6/B0JCVKHgwAuD99WXXFM9oRuVwP1XpiuJ2D9AZv
6h0kA4My4RqS0G+HDWvvVTsgNIisBg0X3yY20Me3iE4dG1DRTKPSf4L8UDRaBIkG
86xF1lmJqDHCrdGEoGeL0GPkdQwx5JZuryUf1xJdG6A64lYWljf6jCPbT7Z5JzoL
6kBTSCDmS2hnrEs+iCXjelzsv/DRZNZaQnCxUbhS+nPMkJJ+zU6tm98OQsTaURB2
vg4NVXpiOlSp9bEeTYe5HlYZQzHucdMlsv/s09BBdh8nrVnrcUQx4oC526+8165Z
P4dNfiAbZjR+bVcouSOMcqkh6QJFqtaBdN1v//7rI83iQiNw3onpxFDsLhZsjESA
h4YRBLcyXHv6qQJos+BMgE7FvTkCuV2C34bEnzVHnVvanquNvCx4cPe1oAKwJpKG
OLvMQH6wdpp9wXNXiVMvWLoQBgLbkFgw1McVg+KV01ah1E6Er3YxFL0u/blJYJyC
/6urwqUrA1VJCf9XyvPWlKpJjSv8EpWK4VyY9fbHUt88hkLEWQQPem7Yv0QNhZ41
bVYbliN5VcopeBucrNhsPlEjxOO68EeWA1JqhyLmyAdbI6eqysA+6ml807QOEe2G
joRwygOCCnlnq3Fw9j5h
=nKGV
-----END PGP SIGNATURE-----

--AQYPrgrEUc/1pSX1--
