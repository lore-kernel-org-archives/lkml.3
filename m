Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaHUUNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:13:04 -0400
Received: from sauhun.de ([89.238.76.85]:59371 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbaHUUND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:13:03 -0400
Date: Thu, 21 Aug 2014 15:12:46 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: Max Schwarz <max.schwarz@online.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Addy Ke <addy.ke@rock-chips.com>, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, huangtao@rock-chips.com, hl@rock-chips.com,
        yzq@rock-chips.com, zyw@rock-chips.com, linux-kernel@vger.kernel.org,
        kever.yang@rock-chips.com, linux-rockchip@lists.infradead.org,
        xjq@rock-chips.com, linux-i2c@vger.kernel.org,
        caesar.wang@rock-chips.com, cf@rock-chips.com, hj@rock-chips.com,
        zhengsq@rock-chips.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] i2c: rk3x: fix bug that cause transfer fails in master
 receive mode
Message-ID: <20140821201246.GB1443@katana>
References: <1408643457-7126-1-git-send-email-addy.ke@rock-chips.com>
 <53F634AF.1010303@cogentembedded.com>
 <20140821181738.GA1443@katana>
 <5150326.5TB64kCfF4@typ>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <5150326.5TB64kCfF4@typ>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Actually, reads with >32 bytes of data are possible with the controller. =
The=20
> hw returns the data in 32 byte chunks. Our chunk handling code is just bu=
ggy.=20

Understood. Then, I'd prefer 'chunk' in the commit message instead of
'transaction'.


--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9lK9AAoJEBQN5MwUoCm2kKMP/iFe9IoYBubgYLiwvIsXFwDX
isEjEACKJgZZyDXtDXIXa/4augAAWf/KmVWc7GRnsakWmUK1dDaPEeBnkfm6Jrzi
Knx6s0kh7Zw94HmE3lcecxjH4hIf7yNr5uih1o4XL5XoQzwXE92HEXYjNrC1+1Rs
ebOMM2F2N6mhi+zLhbsgcGO5HKEcJ9OTTOCDuGbewrmbQ8FI2vuHcBt0g+ehh4Qc
ojH1xQC3Xe8cdlB+4xMth0xesygMihQPq//teDaRoxpB1c2YkcC+zpKG0IcpPCxy
wNTZgLqwiyYruyffnZxXDx5+fHqSnKFiFhjZ9j39H4ATC2k3FH8Hy8UP2feHQDud
pL7x1tJOtc0n8F5Mm6dvBGf8iOVbN34QTME1/LO5ALJHeECU7Tm8vSUWQ+49h3FD
xX8Ep/uTAQT8VdiiZSECjctgKffhNd00PU8hUFUuAOn4o8QYDU+5cedbCFtBzYZm
pwyRXamKL4ZOgo50W8s6EASKJbUU0zD3rbjQr2KVjUkLfMR49XpuTf5PZyEKMSHO
8idUYTEaq70BEfpw/hbg/ph7sSSAGU1+5zgYPmq+2dc9RPsSrlgroOdWZjZVso+I
nOQN9hP7skwXKlkyU+p3faAoVkd/4RTdzN7pYZis4+Fzu97wNQSVSScSfmBS3KEK
XAJVHX3zKE7Nqet9hnJc
=2+8X
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
