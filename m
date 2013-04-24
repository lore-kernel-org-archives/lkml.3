Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab3DXHlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:41:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50756 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3DXHlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:41:19 -0400
Date: Wed, 24 Apr 2013 09:41:15 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: tbergstrom@nvidia.com, amerilainen@nvidia.com, markz@nvidia.com,
        swarren@nvidia.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next RESEND] gpu: host1x: drm: fix missing unlock on
 error
Message-ID: <20130424074114.GA2833@avionic-0098.mockup.avionic-design.de>
References: <CAPgLHd8X3pLTM5vsTnHWL3g9GNOrxVF-LkmGWp6_doFkX2_LcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <CAPgLHd8X3pLTM5vsTnHWL3g9GNOrxVF-LkmGWp6_doFkX2_LcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:mMKJFEj2rjilqQbfPX6nCt4NH4XBu/vvaed+m0J51WF
 FaCVeX7xyEKVgy/qM897Jz40tMG1hVaFBb2bvzQQGKElaCKbhC
 7NBEUeW6IebW6vxTTj4IraYF0COLiVvL+A6TzvDah2UYwnDVGW
 4sWLqXcIFJxGSKwD4kAxinRZ+nI2eUWxJd1HvgZItiW+wL4ux2
 kRRkhgHubfaPMO67L/bnvzBIFO5IgLqCQwVB2lYRnPmADg+Gk3
 Y2UUnbocxLapTVgh1NUIQvM6HfMphzBiHxgQX4zyic9ZrG0GgU
 p2jV2nOBxju8RHFGlnzlIU76rq3a1+g8h3UpHQYNJ5OI8JyQpQ
 xJExAm4SSzNotbScOY4pOqdr5t1JV6wEAeDBtKiqsbNCJoNTWE
 WaHsfuit9GsWr4dpEJNtxBX6Ic53cZHJmk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2013 at 10:48:23AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Add the missing unlock before return from function host1x_drm_init() and
> host1x_drm_exit() in the error handling case.
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

I've applied this to my fixes branch with a small modification to the
subject prefix. I'd like to stick with "drm/tegra: " for things that
touch the DRM parts exclusively.

Thierry

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRd4yaAAoJEN0jrNd/PrOhcJEQAIPdKr+myUpp7AwT8ch9vmxt
tOxnSt3na/tVKabuXhjUNQN3eVzwRtt2pNEAvq7ZVILfFldJEvNjEG031LQTyaZ3
X9IXQX3OdSUZv8DijoXe+yve6AbKxBRL8TzVycCuehn24zAlqdlIctUQcltr4ZMA
N0T49eX/JneoOZkVDZ34sKaLgqrhy1o+Q/Cj65G74IV9jtg5stww0Z1w6NHVXrLp
TDe3+IzOkXUOmU+8WsH91C9+9yzPo6F381uVrJwrZZ4nwVftBK9+giE4NYzxIImG
ZZMcbDK5ol4e52i9OLzZY4YgoFuNeBi60TE/Sih82ijniXMq95cpu2O+UWOZPl0l
ENfq2O95uzsexy2uXmqpbhdJDFPMR+Xili+4OalBEvkNMkMAI+5474O3sK4B1EcI
7HBNBdODH69YPKHtAN/Mkig9oJOsWmxy/bEZHTH7HGLzwSeJ4JAbbhj0eYmOSym0
6oku4JCOlrrE8sNZ5UhfwwK+MWi4QAqtWP4ZPlBAPj5jPauxU0N/9qeeekhxtsc3
8Lw5H+dRjEoYRE7B3OJIg27bFAtpBRuWUEjVlLviyOxDG4NDstInoMDiercKSugA
wK9f1LhQHAv2BpxgUswqXL0dQoP3KyIBLUUCOgLcJQI2WbY0m9QQR7sBff7JDulG
MsX6/+mpbgNH6KLznbSu
=lORr
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
