Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaEUKth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:49:37 -0400
Received: from sauhun.de ([89.238.76.85]:47044 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaEUKtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:49:36 -0400
Date: Wed, 21 May 2014 12:49:30 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Baruch Siach <baruch@tkos.co.il>,
        Wan ZongShun <mcuos.com@gmail.org>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c/nuc900: fix ancient build error
Message-ID: <20140521104929.GP2708@katana>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-11-git-send-email-arnd@arndb.de>
 <20140514162725.GG12911@katana>
 <4944869.eRrWyMmW4d@wuerfel>
 <20140514191749.GA25709@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRkqPRiqIDKgfg/F"
Content-Disposition: inline
In-Reply-To: <20140514191749.GA25709@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRkqPRiqIDKgfg/F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 09:17:49PM +0200, Wolfram Sang wrote:
>=20
> > For the moment, I'd leave this up to Wan ZongShun. He has in the past
> > at least replied to emails about the platform, even though there hasn't
> > been any new development.
>=20
> Agreed. Let's wait for his response. If there is none, I'll think about
> removing the driver.
>=20

Wan ZongShun, final call before this driver gets removed next week.


--TRkqPRiqIDKgfg/F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTfIS5AAoJEBQN5MwUoCm2wasQAInDYBvfhxgwh6mjTeBXbuWw
2yEoa7vFMQjN4mPQ3mBGaXF7ub1ZsoBrBG9waGhA4d2VP5GF3A9efji1aqvw49m/
+3tvQqie0yh56M6AISKKY9UNsqzqW9tb7tox6W1VP86KY2OFvDtZMU+RgwZURVV3
UTqo4lx6rT+Xr/yjOyWT/f7imCZI8pkhJR1sSQIHNUHcMrRieZBQRoURtTydj1Zl
NsgWWSfbSBAqSIKFTcT7ylPpK9b3/7NVINDQnpLxsadJQZ3GxVWpGsfKur3jFmy0
Q2/NsYqBXnSZW8ptmAKb+Os1qsaVk07ljZlg2z0G7LbJPlMCfraHradCgAZKojUc
RHknkXoZqofqhbDDjOTnAuXznmxhVgXoE9Tvfh7RaUSmpy4Vb5CjEM3hsISrfPY+
Ulv0KDPKZzp2kM5jFh3UwZOEF11FwijtF09Ldt57r/Wv33NaxPpJNrwRGDYcWvLB
vQPTlFxvVFRE5mnHUoYX91WdaeduGVfaNOcck4N/Z0zyVlsACpqzNFlk3dh2SfHm
6YbNkuEFzLsDAhXVojGiSvcHLxQhpPtBZbPWwK6vpPoI4FpYqyuW0p9cLFP2stYu
ta4wbMPkkePT8J1ftL2weBwqpFxCKgZk+FxZiy9iViGBWqZlGQbEuaXY7fSrqFuO
/SHYjl4r6rbX7sLK027G
=B0sq
-----END PGP SIGNATURE-----

--TRkqPRiqIDKgfg/F--
