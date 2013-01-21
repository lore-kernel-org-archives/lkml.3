Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3AUJUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:20:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:60814 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3AUJUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:20:10 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-02-50fd08488a76
Message-id: <1358760001.8234.150.camel@kjgkr>
Subject: Re: [patch] f2fs: use _safe() version of list_for_each
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Mon, 21 Jan 2013 18:20:01 +0900
In-reply-to: <20130121083245.GA11592@core.coreip.homeip.net>
References: <20130120150258.GB32551@elgon.mountain>
 <20130121083245.GA11592@core.coreip.homeip.net>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-mVzLkufZ6Pn58kDADyt2"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t8zY10Pjr8BBo9WqVhsvSVtcXnXHDYH
	Jo/Pm+QCGKO4bFJSczLLUov07RK4MuZdjy+4zVexdFVuA2MDbxcjJ4eEgInEhq8rmSBsMYkL
	99azdTFycQgJLGOU2PrtPCNM0a8TX1kgEtMZJebtvsMM4bxmlFh2uoEVpIpXQFeie+FNoAQH
	h7CAvcSm84EgJpuAtsTm/QYgFUICihJv998FqxYR0JfYPvsXI8gYZpCZTfeXgF3BIqAq8WXR
	djaQXk4BG4lLq0QgelMlFm/5wwJi8wuISpxs/QR2G7NAlcSDtg5WiDuVJHa3d7JDXCMo8WPy
	PbCbJQRusUu8WNPICjFfQOLb5EMsIPMlBGQlNh1ghuiVlDi44gbLBEbxWUjGzkIyCiKuKdG6
	/Tc7hK0tsWzha2YI21Zi3br3UDU2EpuuLmCEsOUltr+dw7yAkX0Vo2hqQXJBcVJ6rpFecWJu
	cWleul5yfu4mRkg0Su9gXNVgcYhRgINRiYc3oe9PgBBrYllxZe4hRhWgOY82rL7AKMWSl5+X
	qiTC+3MGUJo3JbGyKrUoP76oNCe1+BBjFdBzE5mlRJPzgQkkryTe0NjYxMzE1MTc0tTclCrC
	SuK8jKeeBAgJpCeWpGanphakFsEsZ+LglGpgzDWXFHVeJbyuc5mmmHHRntWxlbF+ZhNinjiF
	2TEkp6Y2ttwtu/J4ovCKFfqvll8K3MIjJX44zfKJSesdDy1Ru/c+OkVuydv/xe10333GafmN
	snsznrZuOnf7oeTxwhXCy89NEL8+ySs6cSaPG+cDkz8/We5XPVSOu9738am4d2e90887mV0m
	SizFGYmGWsxFxYkA8m2gnS0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jQV0Pjr8BBme/ylhsvSVtcXnXHDYH
	Jo/Pm+QCGKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ0
	3TJzgCYrKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDPmXY8vuM1XsXRV
	bgNjA28XIyeHhICJxK8TX1kgbDGJC/fWs3UxcnEICUxnlJi3+w4zhPOaUWLZ6QZWkCpeAV2J
	7oU3gRIcHMIC9hKbzgeCmGwC2hKb9xuAVAgJKEq83X8XrFpEQF9i++xfjCBjmEFmNt1fwgSS
	YBFQlfiyaDsbSC+ngI3EpVUiEL2pEou3/AG7h19AVOJk6ydGEJtZoEriQVsHK8SdShK72zvZ
	Ia4RlPgx+R7LBEbBWUjKZiFJQcQ1JVq3/2aHsLUlli18zQxh20qsW/ceqsZGYtPVBYwQtrzE
	9rdzmBcwsq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI71Z9I7GFc1WBxiFOBgVOLhTej7
	EyDEmlhWXJl7iFEFaM6jDasvMEqx5OXnpSqJ8P6cAZTmTUmsrEotyo8vKs1JLT7EOJERGBoT
	maVEk/OBCSqvJN7Q2MTMyNLIzMLIxNyclsJK4ryMp54ECAmkJ5akZqemFqQWwRzFxMEp1cDI
	zb+HeyG/rFHQrHpuVtdXVcvU2c75se25cLLNZHbSv5O1Vm4cn9afrZ8audQltuF56G3R7Udr
	y6/qnLEoeMpcvi3aLW338csL6lcm+UuqiT9b7PNIKfNfwMXpcxY+Ovt0+/mzWaoVbJlXpx/8
	enSCR/GChhcnHxW8b+RMn1/H6+00ubjmzcHLSizFGYmGWsxFxYkAeWC3e3QDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mVzLkufZ6Pn58kDADyt2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-01-21 (=EC=9B=94), 00:32 -0800, Dmitry Torokhov:
> On Sun, Jan 20, 2013 at 06:02:58PM +0300, Dan Carpenter wrote:
> > This is calling list_del() inside a loop which is a problem when we try
> > move to the next item on the list.  I've converted it to use the _safe
> > version.  And also, as a cleanup, I've converted it to use
> > list_for_each_entry instead of list_for_each.
> >=20
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > Static analysis stuff.  Untested.  Please review carefully.
>=20
> Makes sense to me.
>=20
> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>=20

No doubt, applied.
Thanks,

--=20
Jaegeuk Kim
Samsung

--=-mVzLkufZ6Pn58kDADyt2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ/QhBAAoJEEAUqH6CSFDSDloP/396aN54a3isOyAyE7hXuS3N
I7P3ToiW19Fag2w+g1/Xip/XBMUST8FOKKL0A1IHXvmLy6DrXruYt/SmHs8MqtWu
DAGC3ZXnZ1RAqKuqrH76xeonWYkn5QY2IVsUnS4wXYyWN7GfdwEv1Sn1VhOWDLho
qPApZGLkqPmhTgyr8uujIcp/CKtoXLpCzJTYxIfBvn7WxgYC/X082yPJOcDEFpAu
2IN+F8KnZ0wUv9PggdRhEet7qj5WJKd9KSpLtJPhZbNAS9HMjHS8JIWlmc8n0Srk
5Jc4BXceNbBUJETYumA3kr/KyfIerU9uD3okJEZ1lXLZVww6i5vr5LEjkv2BrOUd
LFM6UipSCrjaOprW70Vzs7pFAt3H5JZq2LipT1nsTeAEHJZ4y+khl/Eh4f0Z55NS
gulUYjoi2Qt8jwnaGcLiiUqhgUiYovslVoEUq7UtqJOzyqhQtNUMvbGsCn9n8RAo
ifz8yQ56Uie3z+Jqla+w5XDFLUSZE+mS4cKKkyZcvYxJ2cf34WQyBE14FIUA4s+W
q2z0CWw8heGTQN4cVsRWVHO09FDZ3SA1DdNZD5f6j8sYZTcRFn9/VoC+WnQRWkqD
v0LPAegIdsNPY5pFLARNiP0mLgnLyjGu3kNVyp++4V0tFQFdUAh2n3UEaq0i7bxG
XdkR6uvg9pZoyvbHbQXf
=wF50
-----END PGP SIGNATURE-----

--=-mVzLkufZ6Pn58kDADyt2--

